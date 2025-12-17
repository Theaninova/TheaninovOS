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
    environment.systemPackages = with pkgs; [ glib ];

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    home-manager.users.${username} = {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        package = null;
        portalPackage = null;
        settings = {
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };
          input.numlock_by_default = true;
        };
        plugins = with pkgs.hyprlandPlugins; [
        ];
      };
      home = {
        packages = with pkgs; [ grim ];
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          GDK_BACKEND = "wayland,x11,*";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
          # https://github.com/swaywm/sway/issues/6272
          _JAVA_AWT_WM_NONREPARENTING = "1";
        };
      };
      xdg.configFile."uwsm/env".source = pkgs.writeText "env" (
        lib.strings.concatLines (
          lib.attrsets.mapAttrsToList (
            k: v: "export ${builtins.toString k}=${builtins.toString v}"
          ) config.home-manager.users.${username}.home.sessionVariables
        )
      );
      systemd.user.services = {
        "flatpak-managed-install".Unit = {
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
      };
      services.polkit-gnome.enable = true;
    };

    systemd.services = {
      "flatpak-managed-install" = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };

    security.pam.services.gdm.enableGnomeKeyring = true;
    security.pam.services.hyprland.enableGnomeKeyring = true;

    services = {
      kmscon = {
        enable = true;
        hwRender = true;
      };
      greetd = {
        enable = true;
        greeterManagesPlymouth = false;
        settings = {
          initial_session = {
            command = "uwsm start ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop";
            user = username;
          };
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --asterisks --remember --user-menu --cmd 'uwsm start hyprland-uwsm.desktop'";
            user = username;
          };
        };
      };
      dbus = {
        enable = true;
        implementation = "broker";
      };
      pcscd.enable = true;
      gvfs.enable = true;
    };
    programs.dconf.enable = true;
  };
}
