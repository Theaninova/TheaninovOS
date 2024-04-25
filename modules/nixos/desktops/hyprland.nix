{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.desktops.hyprland;
in
{
  options.desktops.hyprland = {
    enable = lib.mkEnableOption "Enable a DE based on Hyprland";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      systemPackages = with pkgs; [ glib ];
    };

    programs.hyprland.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };

    services = {
      greetd = {
        enable = true;
        settings = {
          initial_session = {
            command = "${pkgs.hyprland}/bin/Hyprland &> /dev/null";
            user = username;
          };
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks";
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
  };
}
