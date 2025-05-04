{
  config,
  lib,
  username,
  ...
}:

let
  cfg = config.shell.components.swaync;
in
{
  options.shell.components.swaync = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable a pre-configured notification center");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      services.swaync = {
        enable = true;
        settings = {
          positionX = "center";
          positionY = "top";
          fit-to-screen = false;
          control-center-width = 600;
          control-center-height = 800;
          control-center-margin-top = 2;
          control-center-margin-bottom = 2;
          control-center-margin-right = 1;
          control-center-margin-left = 0;
          notification-window-width = 400;
          notification-icon-size = 48;
          notification-body-image-height = 160;
          notification-body-image-width = 200;
          image-visibility = "when-available";
        };
      };
      programs.waybar.settings.mainBar = {
        modules-center = lib.mkAfter [
          "custom/notification"
        ];

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "󰂚";
            none = "󰂜";
            dnd-notification = "󰂠";
            dnd-none = "󰪓";
            inhibited-notification = "󰂛";
            inhibited-none = "󰪑";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰪑";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };
    };
  };
}
