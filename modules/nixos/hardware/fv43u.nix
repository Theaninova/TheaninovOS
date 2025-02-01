{
  lib,
  config,
  username,
  pkgs,
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

    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = {
        general.layout = "master";
        master = {
          orientation = "center";
          always_center_master = true;
          mfact = 0.4;
        };
        monitor = [
          "DP-3,3840x2160@144,0x0,1,bitdepth,10"
          "DP-3,addreserved,340,0,0,0"
        ];
        xwayland.force_zero_scaling = true;
        misc.vrr = 2; # VA suffers from VRR flicker
      };

      programs.waybar.settings.mainBar."custom/brightness" =
        let
          tmpFile = "${config.home-manager.users.${username}.xdg.configHome}/gbmonctl-brightness";
        in
        {
          return-type = "json";
          exec = pkgs.writeShellScript "waybar-brightness" ''
            BRIGHTNESS=$(cat ${tmpFile} || echo "0")
            if [ "$BRIGHTNESS" -lt ${toString (100 / 7 * 1)} ]; then
              ICON="󰃚"
            elif [ "$BRIGHTNESS" -lt ${toString (100 / 7 * 2)} ]; then
              ICON="󰃛"
            elif [ "$BRIGHTNESS" -lt ${toString (100 / 7 * 3)} ]; then
              ICON="󰃜"
            elif [ "$BRIGHTNESS" -lt ${toString (100 / 7 * 4)} ]; then
              ICON="󰃝"
            elif [ "$BRIGHTNESS" -lt ${toString (100 / 7 * 5)} ]; then
              ICON="󰃞"
            elif [ "$BRIGHTNESS" -lt ${toString (100 / 7 * 6)} ]; then
              ICON="󰃟"
            else
              ICON="󰃠"
            fi

            echo "{\"text\": \"$ICON $BRIGHTNESS%\"}"
          '';
          on-scroll-up = pkgs.writeShellScript "waybar-brightness-up" ''
            BRIGHTNESS=$(cat ${tmpFile} || echo "0")
            BRIGHTNESS=$((BRIGHTNESS + 5))
            BRIGHTNESS=$((BRIGHTNESS > 100 ? 100 : BRIGHTNESS))
            echo $BRIGHTNESS > ${tmpFile}
            ${pkgs.gbmonctl}/bin/gbmonctl -prop brightness -val $BRIGHTNESS
          '';
          on-scroll-down = pkgs.writeShellScript "waybar-brightness-up" ''
            BRIGHTNESS=$(cat ${tmpFile} || echo "0")
            BRIGHTNESS=$((BRIGHTNESS - 5))
            BRIGHTNESS=$((BRIGHTNESS < 0 ? 0 : BRIGHTNESS))
            echo $BRIGHTNESS > ${tmpFile}
            ${pkgs.gbmonctl}/bin/gbmonctl -prop brightness -val $BRIGHTNESS
          '';
          exec-on-event = true;
          exec-if = "sleep 0.1";
          interval = "once";
        };
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
