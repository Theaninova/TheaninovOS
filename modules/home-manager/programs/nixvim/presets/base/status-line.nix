{ lib, config, ... }:
let
  cfg = config.presets.base.status-line;
in
{
  options.presets.base.status-line = {
    enable = lib.mkEnableOption "status line";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      notify = {
        enable = true;
        backgroundColour = "#000000";
      };
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
