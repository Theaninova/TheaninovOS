{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.shell.components.flameshot;
in
{
  options.shell.components.flameshot = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable a pre-configured flameshot");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland = {
        settings = {
          bind = [
            "SUPER_SHIFT,V,exec,XDG_CURRENT_DESKTOP=sway uwsm app -- flameshot gui --clipboard"
          ];
          windowrulev2 = [
            "float,class:^(flameshot)$"
            "animation fade,class:^(flameshot)$"
          ];
        };
      };

      systemd.user.services."flameshot" = {
        Unit.After = lib.mkForce [ "graphical-session.target" ];
        Install.WantedBy = lib.mkForce [ "graphical-session.target" ];
      };
      services.flameshot = {
        enable = true;
        package = pkgs.flameshot.overrideAttrs (
          final: prev: {
            cmakeFlags = [
              "-DUSE_WAYLAND_CLIPBOARD=1"
              "-DUSE_WAYLAND_GRIM=true"
            ];
            nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.libsForQt5.kguiaddons ];
          }
        );
        settings = {
          General = {
            uiColor = "#99d1db";
            showDesktopNotification = false;
            disabledTrayIcon = true;
          };
        };
      };
    };
  };
}
