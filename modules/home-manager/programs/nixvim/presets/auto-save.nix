{ lib, config, ... }:
let
  cfg = config.presets.auto-save;
in
{
  options.presets.auto-save = {
    enable = lib.mkEnableOption "auto save";
    disableOnStart = lib.mkEnableOption "disable auto save on start";
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
        function PerformAutoSave(buf)
          buf = buf or vim.api.nvim_get_current_buf()

          if vim.b.disable_autosave or vim.g.disable_autosave then return end
          if vim.fn.getbufvar(buf, "&modifiable") ~= 1 then return end
          if not vim.api.nvim_buf_get_option(buf, 'modified') then return end
          if vim.api.nvim_buf_get_option(buf, 'buftype') ~= "" then return end

          vim.api.nvim_buf_call(buf, function()
            vim.cmd('silent! w')
            print("Auto save at " .. os.date("%H:%M:%S"))
          end)
        end
      '';

    autoCmd = [
      {
        event = cfg.event;
        pattern = [ "*" ];
        callback.__raw = # lua
          "function(args) PerformAutoSave(args.buf) end";
      }
    ];

    globals.disable_autosave = cfg.disableOnStart;

    userCommands.ToggleAutoSave = {
      bang = true;
      command.__raw = # lua
        ''
          function(args)
            if args.bang then
              vim.b.disable_autosave = not vim.b.disable_autosave
            else
              vim.g.disable_autosave = not vim.g.disable_autosave
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
        action = "<cmd>:ToggleAutoSave<CR>";
      }
      {
        key = "<leader>aS";
        mode = "n";
        options.silent = true;
        action = "<cmd>:ToggleAutoSave!<CR>";
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

      /*neo-tree.eventHandlers.window_before_open = # lua
        "function() PerformAutoSave() end";*/

      lualine.sections.lualine_x = lib.mkOrder 700 [
        # lua
        "(vim.g.disable_autosave or vim.b.disable_autosave) and '󱙃' or nil"
      ];
    };
  };
}
