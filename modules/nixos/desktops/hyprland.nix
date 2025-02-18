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
        systemd.enable = false;
      };
      home = {
        packages = with pkgs; [ grim ];
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          GDK_BACKEND = "wayland,x11,*";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
          CLUTTER_BACKEND = "wayland";
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
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };

    services = {
      seatd = {
        enable = true;
        user = username;
      };
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
            command = "${lib.getExe pkgs.greetd.tuigreet} --asterisks --remember --user-menu --cmd 'uwsm start hyprland-uwsm.desktop'";
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
