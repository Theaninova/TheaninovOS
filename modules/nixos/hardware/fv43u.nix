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
    hdr = mkOption {
      type = types.bool;
      default = false;
      description = "Enable HDR support for the Gigabyte FV43U monitor.";
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.subpixel.rgba = "bgr";
    hardware.gbmonctl.enable = true;
    boot.kernelParams = [ "video=DP-3:3840x2160-30@144" ];
    services.colord.enable = true;
    environment.systemPackages = [
      (pkgs.runCommandNoCC "fv43u_icc" { } ''
        mkdir -p $out/share/color/icc
        cp ${./fv43u.icc} $out/share/color/icc/fv43u.icc
      '')
    ];

    home-manager.users.${username} =
      let
        monitorline = "DP-3,3840x2160@144,0x0,1,bitdepth,10,cm,${if cfg.hdr then "hdr" else "srgb"}";
      in
      {
        programs.mpv.config = {
          vo = "gpu-next";
          gpu-api = "vulkan";
          gpu-context = "waylandvk";
          target-colorspace-hint = "auto";
        };
        programs.niri.settings = {
          prefer-no-csd = true;
          outputs."DP-3" = {
            scale = 1;
            mode = {
              width = 3840;
              height = 2160;
              refresh = 143.999;
            };
            variable-refresh-rate = "on-demand";
          };
          layout.struts.top = 340;
        };
        wayland.windowManager.hyprland.settings = {
          general.layout = "master";
          master = {
            orientation = "center";
            slave_count_for_center_master = 0;
            mfact = 0.4;
            allow_small_split = true;
          };
          render.direct_scanout = 0;
          /*
            monitor = [
              "${monitorline},sdrbrightness,1.3"
              "DP-3,addreserved,340,0,0,0"
            ];
          */
          monitorv2 = {
            output = "DP-3";
            mode = "3840x2160@144";
            position = "0x0";
            scale = 1;
            bitdepth = 10;
            addreserved = "340,0,0,0";
            cm = if cfg.hdr then "hdredid" else "srgb";
            sdr_min_luminance = 0.25;
            sdr_max_luminance = 250;
          };
          xwayland.force_zero_scaling = true;
          misc.vrr = 2; # VA suffers from VRR flicker
          cursor = {
            min_refresh_rate = 48;
            no_break_fs_vrr = 1;
          };
          experimental.xx_color_management_v4 = true;
        };

        programs.waybar.settings.mainBar =
          let
            tmpFile = "${config.home-manager.users.${username}.xdg.configHome}/gbmonctl-brightness";
            cmd =
              if cfg.hdr then
                # sh
                ''
                  BRIGHTNESS=$(cat ${tmpFile} || echo "0")
                  BRIGHTNESS=$(printf "1.%02d" $((BRIGHTNESS / 2)))
                  hyprctl keyword monitor ${monitorline},sdrbrightness,$BRIGHTNESS
                ''
              else
                "${pkgs.gbmonctl}/bin/gbmonctl -prop brightness -val $BRIGHTNESS";
          in
          {
            "custom/saturation" = { };
            "custom/brightness" = {
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
                ${cmd}
              '';
              on-scroll-down = pkgs.writeShellScript "waybar-brightness-up" ''
                BRIGHTNESS=$(cat ${tmpFile} || echo "0")
                BRIGHTNESS=$((BRIGHTNESS - 5))
                BRIGHTNESS=$((BRIGHTNESS < 0 ? 0 : BRIGHTNESS))
                echo $BRIGHTNESS > ${tmpFile}
                ${cmd}
              '';
              exec-on-event = true;
              exec-if = "sleep 0.1";
              interval = "once";
            };
          };
      };
  };
}
