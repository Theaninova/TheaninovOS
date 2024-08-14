{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.lazygit;
in
{
  options.presets.lazygit = {
    enable = lib.mkEnableOption "LazyGit";
    toggleBind = lib.mkOption {
      type = lib.types.str;
      default = "<leader>g";
    };
    commandName = lib.mkOption {
      type = lib.types.str;
      default = "ToggleLazyGit";
    };
  };

  config = lib.mkIf cfg.enable {
    extraConfigLua = # lua
      ''
        LazygitTerminal = require("toggleterm.terminal").Terminal:new({
        	cmd = "${lib.getExe pkgs.lazygit}",
        	dir = "git_dir",
        	direction = "float",

        	on_open = function(term)
        		vim.cmd("startinsert!")
        		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        	end,
        	on_close = function(_)
        		vim.cmd("startinsert!")
        	end,
        })

        function LazygitToggle()
        	lazygit:toggle()
        end
      '';

    userCommands.${cfg.commandName}.command.__raw = # lua
      ''
        function()
          LazygitTerminal:toggle()
        end
      '';

    keymaps = [
      {
        key = cfg.toggleBind;
        mode = "n";
        options.silent = true;
        action = "<cmd>:${cfg.commandName}<CR>";
      }
    ];

    plugins = {
      toggleterm = {
        enable = true;
        settings = {
          direction = lib.mkDefault "vertical";
          size = lib.mkDefault 60;
        };
      };

      which-key.settings.spec = [
        {
          __unkeyed-1 = cfg.toggleBind;
          desc = "Git";
          icon = "";
        }
      ];
    };
  };
}
