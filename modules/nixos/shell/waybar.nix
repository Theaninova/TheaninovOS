{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.shell.components.waybar;
in
{
  options.shell.components.waybar = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable a pre-configured waybar setup");
    mobile = lib.mkEnableOption (lib.mdDoc "Mobile PC");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";

          height = 24;
          reload_style_on_change = true;
          exclusive = true;

          modules-left = (
            if cfg.mobile then
              [
                "battery"
              ]
            else
              [ ]
          );
          modules-center = [
            "clock"
          ];
          modules-right = [
            "privacy"
            "gamemode"
            "tray"
            "pulseaudio"
          ]
          ++ (
            if cfg.mobile then
              [ "backlight" ]
            else
              [
                "custom/brightness"
              ]
          )
          ++ [
            # "custom/theme"
            # "network"
          ];

          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-icons = {
              "alsa_output.usb-Turtle_Beach_Turtle_Beach_Stealth_700_G2_MAX-01.iec958-stereo" = "󰋋";
              "alsa_output.pci-0000_0a_00.4.analog-stereo" = "󰓃";
              "alsa_output.pci-0000_08_00.1.hdmi-stereo-extra4" = "󰽟";
              "alsa_output.usb-Blue_Microphones_Yeti_Stereo_Microphone_797_2018_11_12_79383-00.analog-stereo" =
                "󰍬";
              "default" = "󰕾";
            };
            on-click = "pavucontrol --tab=3";
          };

          "backlight" = {
            "format" = "{icon}";
            "format-icons" = [
              "󰃚"
              "󰃛"
              "󰃜"
              "󰃝"
              "󰃞"
              "󰃟"
              "󰃠"
            ];
            "tooltip-format" = "{percent}%";
          };

          "hyprland/workspaces" = {
            format = "{windows}";
            window-rewrite = {
              "class<firefox>" = "󰈹";
              "class<thunderbird>" = "";
              "class<neovide>" = "";
              "class<kitty>" = "";
              "class<OrcaSlicer>" = "󰹛";
              "class<blender>" = "";
              "class<steam>" = "";
            };
            window-rewrite-default = "";
          };

          "network" = {
            "format-icons" = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            "format" = "󰛳";
            "format-wifi" = "{icon}";
            "format-ethernet" = "󰈀";
            "format-disconnected" = if cfg.mobile then "󰤭" else "󰲛";
          };

          "battery" = {
            "format-icons" = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            "format" = "{icon}";
            "format-time" = "{H}:{m}";
            "tooltip-format" = "{capacity}%";
          };

          "custom/theme" = {
            return-type = "json";
            exec-on-event = true;
            exec = pkgs.writeShellScript "waybar-theme" ''
              if [ $(theme mode) = "dark" ]; then
                echo '{"text": "", "tooltip": "Switch to light theme"}'
              elif [ $(theme mode) = "auto" ]; then
                echo '{"text": "󰖛", "tooltip": "Switch to dark theme"}'
              else
                echo '{"text": "", "tooltip": "Switch to dark theme"}'
              fi
            '';
            exec-if = "sleep 1";
            interval = "once";
            on-click = "theme toggle";
            on-click-right = "theme auto";
            on-click-middle = "theme wallpaper";
          };
        };
      };
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
    };
  };
}
