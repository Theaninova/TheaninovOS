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
    hardware = {
      gbmonctl.enable = true;
      firmware = [
        (pkgs.runCommandNoCC "fv43u_edid" { } ''
          mkdir -p $out/lib/firmware/edid
          cp ${./fv43u_edid.bin} $out/lib/firmware/edid/fv43u.bin
        '')
      ];
    };
    boot = {
      kernelParams = [
        "drm.edid_firmware=DP-3:edid/fv43u.bin"
        "video=DP-3:3840x2160-30@144"
      ];
      initrd.extraFiles."lib/firmware/edid/fv43u.bin".source =
        pkgs.runCommandLocal "fv43u_edid" { }
          "cp ${./fv43u_edid.bin} $out";
    };
    services.colord.enable = true;
    environment.systemPackages = [
      (pkgs.runCommandNoCC "fv43u_icc" { } ''
        mkdir -p $out/share/color/icc
        cp ${./fv43u.icc} $out/share/color/icc/fv43u.icc
      '')
    ];

    home-manager.users.${username} = {
      home.sessionVariables = {
        ENABLE_HDR_WSI = "1";
        DXVK_HDR = "1";
      };
      wayland.windowManager.hyprland.settings = {
        general = {
          layout = "master";
          allow_tearing = true;
        };
        master = {
          orientation = "center";
          slave_count_for_center_master = 0;
          mfact = 0.4;
        };
        # render.direct_scanout = 1;
        monitor = [
          "DP-3,3840x2160@144,0x0,1,bitdepth,10,cm,auto"
          "DP-3,addreserved,340,0,0,0"
        ];
        xwayland.force_zero_scaling = true;
        misc.vrr = 2; # VA suffers from VRR flicker
        cursor = {
          min_refresh_rate = 48;
          no_break_fs_vrr = 1;
        };
        experimental = {
          xx_color_management_v4 = true;
        };
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
  };
}
