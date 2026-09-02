{
  lib,
  config,
  username,
  ...
}:
with lib;

let
  cfg = config.hardware.q3279vwf;
in
{
  options.hardware.q3279vwf = {
    enable = mkEnableOption "Enable optimisations for the AOC Q3279VWF monitor";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.subpixel.rgba = "bgr";

    home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
      config = {
        general.layout = "master";
        master = {
          orientation = "right";
          mfact = 0.65;
          always_keep_position = true;
        };
        xwayland.force_zero_scaling = true;
        misc.vrr = 0; # VA suffers from VRR flicker
      };
      workspace_rule = [
        {
          workspace = "m[DP-1]";
          layout_opts.orientation = "top";
        }
      ];
      monitor = [
        {
          output = "HDMI-A-1";
          mode = "2560x1440@75";
          position = "0x0";
          scale = 1;
        }
        {
          output = "DP-1";
          mode = "1920x1080@144";
          position = "auto-center-right";
          scale = 1;
          transform = 3;
        }
      ];
    };
  };
}
