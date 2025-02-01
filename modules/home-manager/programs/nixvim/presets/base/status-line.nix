{ lib, config, ... }:
let
  cfg = config.presets.base.status-line;
in
{
  options.presets.base.status-line = {
    enable = lib.mkEnableOption "status line";
  };

  config = lib.mkIf cfg.enable {
    opts.showmode = false;
    plugins = {
      notify = {
        enable = true;
        stages = "static";
      };
      telescope = {
        enable = true;
        keymaps."<leader>n" = # vim
          "notify";
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>n";
          desc = "Notifications";
          icon = "󰍩";
        }
      ];
      lualine = {
        enable = true;
        settings = {
          options = {
            globalstatus = true;
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "┊";
              right = "┊";
            };
          };
          sections = {
            lualine_a = [
              {
                __unkeyed-1 = "mode";
                separator = {
                  right = "";
                  left = "";
                };
                icon = "";
              }
            ];
            lualine_x = lib.mkAfter [ { __unkeyed-1 = "filetype"; } ];
            lualine_z = [
              {
                __unkeyed-1 = "location";
                separator = {
                  right = "";
                  left = "";
                };
              }
            ];
          };
        };
      };
    };
  };
}
