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

          modules-left = [
            # "hyprland/workspaces"
          ];
          modules-center = [
            "clock"
            "systemd-failed-units"
          ];
          modules-right = [
            "privacy"
            "gamemode"
            "tray"
            "custom/brightness"
            "custom/theme"
          ];

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

          "custom/theme" = {
            return-type = "json";
            exec-on-event = true;
            exec = pkgs.writeShellScript "waybar-theme" ''
              if [ $(theme mode) = "dark" ]; then
                echo '{"text": "", "tooltip": "Switch to light theme"}'
              else
                echo '{"text": "", "tooltip": "Switch to dark theme"}'
              fi
            '';
            exec-if = "sleep 1";
            interval = "once";
            on-click = "theme toggle";
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
