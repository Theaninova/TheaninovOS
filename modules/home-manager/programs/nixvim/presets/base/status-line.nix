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
      which-key.registrations."<leader>n" = "Notifications";
      lualine = {
        enable = true;
        globalstatus = true;
        sectionSeparators = {
          left = "";
          right = "";
        };
        componentSeparators = {
          left = "┊";
          right = "┊";
        };
        sections = {
          lualine_a = [
            {
              name = "mode";
              separator = {
                right = "";
                left = "";
              };
              icon = "";
            }
          ];
          lualine_x = lib.mkAfter [ { name = "filetype"; } ];
          lualine_z = [
            {
              name = "location";
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
}
