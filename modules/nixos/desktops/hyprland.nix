{ config, lib, pkgs, username, ... }:

with lib;

let cfg = config.desktops.hyprland;

in {
  options.desktops.hyprland = {
    enable = mkEnableOption (mdDoc "Enable a DE based on Hyprland");
  };

  config = mkIf cfg.enable {
    services.getty.autologinUser = "${username}";
    services.getty.extraArgs = [ "--noclear" "--noissue" "--nonewline" ];
    services.getty.loginOptions = "-p -f -- \\u"; # preserve environment

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals =
        [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-kde ];
    };

    services.pcscd.enable = true;

    # nautilus on non-gnome
    services.gvfs.enable = true;
    # fix pinentry on non-gnome
    services.dbus.packages = with pkgs; [ gcr ];
    services.gnome.gnome-online-accounts.enable = true;
    services.gnome.evolution-data-server.enable = true;

    programs.hyprland.enable = true;
    programs.kdeconnect.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
