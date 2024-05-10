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
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          height = 24;
          reload_style_on_change = true;
          exclusive = true;

          modules-center = [
            "clock"
            "systemd-failed-units"
          ];
          modules-right = [
            "privacy"
            "gamemode"
            "tray"
            "custom/theme"
            #"network"
            #"pulseaudio"
            #"bluetooth"
          ];

          "custom/theme" = {
            return-type = "json";
            exec = pkgs.writeShellScript "waybar-theme" ''
              if [ $(theme mode) = "dark" ]; then
                echo '{"text": "", "tooltip": "Switch to light theme"}'
              else
                echo '{"text": "", "tooltip": "Switch to dark theme"}'
              fi
            '';
            on-click = "theme toggle";
          };
        };
      };
      systemd = lib.mkIf config.desktops.hyprland.enable {
        enable = true;
        target = "hyprland-session.target";
      };
    };
  };
}
