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
          modules-center = [ "clock" ];
          modules-right = [
            "privacy"
            "tray"
          ];

          "custom/theme" = { };
        };
      };
      systemd = lib.mkIf config.desktops.hyprland.enable {
        enable = true;
        target = "hyprland-session.target";
      };
    };
  };
}
