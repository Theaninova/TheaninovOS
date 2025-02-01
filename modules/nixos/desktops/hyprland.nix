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

    # https://github.com/sjcobb2022/nixos-config/blob/70fb548b961c19e9855d2de86ee9569a7a88d976/hosts/common/optional/greetd.nix#L23C1-L33C2
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --remember --remember-session --sessions ${pkgs.hyprland}/share/wayland-sessions";
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
