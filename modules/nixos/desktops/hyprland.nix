{
  config,
  lib,
  pkgs,
  username,
  ...
}:

with lib;

let
  cfg = config.desktops.hyprland;
in
{
  options.desktops.hyprland = {
    enable = mkEnableOption (mdDoc "Enable a DE based on Hyprland");
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-kde
      ];
    };

    services = {
      greetd = {
        enable = true;
        settings = rec {
          initial_session = {
            command = "${pkgs.hyprland}/bin/Hyprland &> /dev/null";
            user = username;
          };
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --sessions ${config.services.xserver.displayManager.sessionData.desktops}";
            user = username;
          };
        };
      };

      dbus.enable = true;

      pcscd.enable = true;

      # nautilus on non-gnome
      gvfs.enable = true;
      # fix pinentry on non-gnome
      dbus.packages = with pkgs; [ gcr ];
      gnome.gnome-online-accounts.enable = true;
      gnome.evolution-data-server.enable = true;
    };

    programs = {
      hyprland.enable = true;
      kdeconnect.enable = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
