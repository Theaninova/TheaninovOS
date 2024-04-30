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

    home-manager.users.${username}.wayland.windowManager.hyprland.settings.monitor = [
      "DP-1,highrr,0x0,1"
      "DP-1,addreserved,300,0,0,0"
    ];

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
