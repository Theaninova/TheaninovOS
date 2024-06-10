{ lib, config, ... }:
let
  cfg = config.presets.auto-save;
in
{
  options.presets.auto-save = {
    enable = lib.mkEnableOption "auto save";
    varName = lib.mkOption {
      type = lib.types.str;
      default = "disable_autosave";
    };
    commandName = lib.mkOption {
      type = lib.types.str;
      default = "AutoSaveToggle";
    };
    event = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "BufHidden"
        "FocusLost"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    extraConfigLua = # lua
      ''
        function AutoSave()
          if not vim.b.${cfg.varName} and not vim.g.${cfg.varName} then
            local bufnr = vim.api.nvim_get_current_buf()
            local modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
            if modified then
              vim.cmd('silent! w')
              print("Auto save at " .. os.date("%H:%M:%S"))
            end
          end
        end
      '';

    autoCmd = [
      {
        event = cfg.event;
        pattern = [ "*" ];
        command = "lua AutoSave()";
      }
    ];

    userCommands.${cfg.commandName} = {
      bang = true;
      command.__raw = # lua
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
    };

    keymaps = [
      {
        key = "<leader>as";
        mode = "n";
        options.silent = true;
        action = "<cmd>:${cfg.commandName}<CR>";
      }
      {
        key = "<leader>aS";
        mode = "n";
        options.silent = true;
        action = "<cmd>:${cfg.commandName}!<CR>";
      }
    ];

    plugins = {
      which-key.registrations = {
        "<leader>a" = {
          name = "Auto Actions";
          s = "Toggle auto-save";
          S = "Toggle auto-save (buffer)";
        };
      };

      neo-tree.eventHandlers.window_before_open = # lua
        ''
          function()
            AutoSave()
          end
        '';

      lualine.sections.lualine_x = lib.mkOrder 700 [
        "(vim.g.${cfg.varName} or vim.b.${cfg.varName}) and '󱙃' or nil"
      ];
    };
  };
}
