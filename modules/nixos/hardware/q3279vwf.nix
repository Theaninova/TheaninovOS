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
    boot.kernelParams = [ "video=2560x1440@75" ];

    home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
      general.layout = "master";
      master = {
        orientation = "right";
        mfact = 0.65;
        always_keep_position = true;
      };
      monitor = [ "DP-1,2560x1440@75,0x0,1" ];
      xwayland.force_zero_scaling = true;
      misc.vrr = 2; # VA suffers from VRR flicker
    };
  };
}
