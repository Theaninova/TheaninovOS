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
      (pkgs.runCommand "fv43u_icc" { } ''
        mkdir -p $out/share/color/icc
        cp ${./fv43u.icc} $out/share/color/icc/fv43u.icc
      '')
    ];

    home-manager.users.${username} = {
      programs.mpv.config = {
        vo = "gpu-next";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";
        target-colorspace-hint = "auto";
      };
      wayland.windowManager.hyprland.settings = {
        config = {
          scrolling = {
            column_width = 0.4;
            focus_fit_method = 0;
            fullscreen_on_one_column = false;
            wrap_focus = false;
          };
          render.direct_scanout = 0;
          xwayland.force_zero_scaling = true;
          misc.vrr = 2; # VA suffers from VRR flicker
          quirks.prefer_hdr = 1;
          cursor = {
            min_refresh_rate = 48;
            no_break_fs_vrr = 1;
          };
        };
        monitor = {
          output = "DP-3";
          mode = "3840x2160@144";
          position = "0x0";
          scale = 1;
          bitdepth = 10;
          reserved_area.top = 80;
          sdr_min_luminance = 0.25;
          sdr_max_luminance = 250;
          icc = toString ./fv43u.icc;
          cm = "dcip3";
        };
      };

      programs.waybar.settings.mainBar =
        let
          tmpFile = "${config.home-manager.users.${username}.xdg.configHome}/gbmonctl-brightness";
          cmd = "${pkgs.gbmonctl}/bin/gbmonctl -prop brightness -val $BRIGHTNESS";
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
