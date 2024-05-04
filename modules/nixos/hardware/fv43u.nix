{
  lib,
  config,
  username,
  ...
}:
with lib;

let
  cfg = config.hardware.fv43u;
in
{
  options.hardware.fv43u = {
    enable = mkEnableOption "Enable optimisations for the Gigabyte FV43U monitor";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.subpixel.rgba = "bgr";
    hardware.gbmonctl.enable = true;
    boot.kernelParams = [ "video=3840x2160@144" ];

    home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
      general.layout = "master";
      master = {
        orientation = "center";
        new_is_master = true;
        always_center_master = true;
        mfact = 0.4;
      };
      monitor = [
        "DP-1,highrr,0x0,1"
        "DP-1,addreserved,340,0,0,0"
      ];
      xwayland.force_zero_scaling = true;
      misc.vrr = 2; # VA suffers from VRR flicker
    };

    programs.steam.gamescopeSession = {
      env = {
        SCREEN_WIDTH = "3840";
        SCREEN_HEIGHT = "2160";
      };
      args = [
        "--hdr-enabled"
        "--hdr-itm-enable"
      ];
    };
  };
}
