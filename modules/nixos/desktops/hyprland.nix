{ config, lib, pkgs, username, ... }:

with lib;

let cfg = config.desktops.hyprland;

in {
  options.desktops.hyprland = {
    enable = mkEnableOption (mdDoc "Enable a DE based on Hyprland");
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals =
        [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-kde ];
    };

    services = {
      getty.autologinUser = "${username}";
      getty.extraArgs = [ "--noclear" "--noissue" "--nonewline" ];
      getty.loginOptions = "-p -f -- \\u"; # preserve environment

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

    /* systemd.services = {
         plymouth-quit-hyprland = mkIf config.boot.quiet.enable {
           description = "Pause plymouth animation";
           conflicts = [ "plymouth-quit.service" ];
           after = [
             "plymouth-quit.service"
             "rc-local.service"
             "plymouth-start.service"
             "systemd-user-sessions.service"
           ];
           serviceConfig = {
             Type = "oneshot";
             ExecStartPre = "${pkgs.plymouth}/bin/plymouth deactivate";
             ExecStartPost = [
               "${pkgs.coreutils}/bin/sleep 30"
               "${pkgs.plymouth}/bin/plymouth quit --retain-splash"
             ];
           };
         };
       };
    */
  };
}
