{ lib, config, ... }:
let
  cfg = config.presets.auto-format;
in
{
  options.presets.auto-format = {
    enable = lib.mkEnableOption "auto-format";
    varName = lib.mkOption {
      type = lib.types.str;
      default = "disable_autoformat";
    };
    commandName = lib.mkOption {
      type = lib.types.str;
      default = "AutoFormatToggle";
    };
  };

  config = lib.mkIf cfg.enable {
    userCommands.${cfg.commandName}.command.__raw = # lua
      ''
        function(args)
          if args.bang then
            vim.b.${cfg.varName} = not vim.b.${cfg.varName}
          else
            vim.g.${cfg.varName} = not vim.g.${cfg.varName}
          end
          local lualine, lib = pcall(require, 'lualine')
          if lualine then
            lib.refresh()
          end
        end
      '';

    keymaps = [
      {
        key = "<leader>af";
        mode = "n";
        options.silent = true;
        action = "<cmd>:${cfg.commandName}<CR>";
      }
      {
        key = "<leader>aF";
        mode = "n";
        options.silent = true;
        action = "<cmd>:${cfg.commandName}!<CR>";
      }
    ];

    plugins = {
      which-key.registrations = {
        "<leader>a" = {
          name = "Auto Actions";
          f = "Toggle auto-format";
          F = "Toggle auto-format (buffer)";
        };
      };

      conform-nvim.formatAfterSave = # lua
        ''
          function(bufnr)
            if vim.g.${cfg.varName} or vim.b[bufnr].${cfg.varName} then
              return
            end
            return { timeout_ms = 500, lsp_fallback = true };
          end
        '';

      lualine.sections.lualine_x = lib.mkOrder 600 [
        "(vim.g.${cfg.varName} or vim.b.${cfg.varName}) and '󱌓' or nil"
      ];
    };
  };
}
