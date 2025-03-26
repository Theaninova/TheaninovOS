{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.shell.components.gnome-keyring;
in
{
  options.shell.components.gnome-keyring = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable the gnome keyring");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings.windowrulev2 = [
        "dimaround,class:^(gcr-prompter)$"
        "noborder,class:^(gcr-prompter)$"
        "rounding 10,class:^(gcr-prompter)$"
        "animation slide,class:^(gcr-prompter)$"
      ];
      home.packages = with pkgs; [
        polkit_gnome
        (gnome-keyring.overrideAttrs (oldAttrs: {
          configureFlags = oldAttrs.configureFlags ++ [
            "--disable-ssh-agent"
          ];
        }))
      ];
      /*
        systemd.user.services = {
          polkit-gnome-authentication-agent-1 = {
            Unit = {
              Description = "Gnome Polkit Agent";
              After = [
                "graphical-session.target"
                "gnome-keyring-daemon.service"
              ];
            };
            Install.WantedBy = [ "graphical-session.target" ];
            Service = {
              ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
              Restart = "on-failure";
            };
          };
          gnome-keyring-daemon = {
            Unit = {
              Description = "Gnome Keyring Daemon";
              After = [ "graphical-session.target" ];
            };
            Install.WantedBy = [ "graphical-session.target" ];
            Service = {
              ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets";
              Restart = "on-failure";
            };
          };
        };
      */
    };
    # fix pinentry on non-gnome
    services.dbus.packages = with pkgs; [ gcr ];
  };
}
