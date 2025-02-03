{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.desktops.hyprland;
  homeConfig = config.home-manager.users.${username};
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
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        GDK_BACKEND = "wayland,x11,*";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
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
      /*
        programs.zsh.initExtraFirst = # sh
        ''
          if uwsm check may-start; then
          	exec uwsm start hyprland-uwsm.desktop > ${homeConfig.xdg.configHome}/uwsm.log 2> ${homeConfig.xdg.configHome}/uwsm.err
          fi
        '';
      */
    };

    systemd.services = {
      "flatpak-managed-install" = {
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };
      greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "journal";
        StandardError = "journal";
        TTYReset = false;
        TTYVHangup = false;
        TTYVTDisallocate = false;
      };
      /*
        "uwsm-display-manager" = {
          description = "UWSM Display Manager";
          conflicts = [ "getty@tty1.service" ];
          after = [
            "systemd-user-sessions.service"
            "plymouth-quit-wait.service"
            "getty@tty1.service"
          ];
          serviceConfig = {
            Type = "simple";
            IgnoreSIGPIPE = "no";
            SendSIGHUP = "yes";
            TimeoutStopSec = "30s";
            KeyringMode = "shared";
            Restart = "always";
            RestartSec = "5";
            StartLimitBurst = "5";
            StartLimitInterval = "30";
          };
          restartIfChanged = false;
          script = ''
            ${pkgs.sudo}/bin/sudo -u ${username} --login uwsm start hyprland-uwsm.desktop
          '';
          environment = {
            DISPLAY = ":0";
            # XDG_RUNTIME_DIR = "/run/user/$(id -u ${username})";
          };
          aliases = [ "display-manager.service" ];
        };
      */
      /*
        "getty@tty1" = {
          overrideStrategy = "asDropin";
          description = "Start Hyprland";
          after = [
            "sysinit.target"
            "initrd-switch-root.service"
            "systemd-udev-trigger.service"
            "seatd.service"
            "systemd-logind.service"
          ];
          wants = [
            "systemd-udev-trigger.service"
            "seatd.service"
            "systemd-logind.service"
          ];
          unitConfig.ConditionPathExists = "/home/${username}";
          onFailure = [ "emergency.target" ];
          serviceConfig.Type = "simple";
          preStart = "+${pkgs.coreutils}/bin/rm -f /run/nologin";
          script = ''
            -${pkgs.util-linux}/bin/agetty -o '-p -f -- \u' --noclear --autologin ${username} %I $TERM StandardOutput=null StandardError=journal
          '';
          wantedBy = [
            "graphical.target"
            "initrd-switch-root.service"
          ];
        };
      */
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

    # https://github.com/sjcobb2022/nixos-config/blob/70fb548b961c19e9855d2de86ee9569a7a88d976/hosts/common/optional/greetd.nix#L23C1-L33C2
    /*
      systemd.services = {
        greetd.serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          StandardOutput = "tty";
          StandardError = "journal"; # Without this errors will spam on screen
          # Without these bootlogs will spam on screen
          TTYReset = true;
          TTYVHangup = true;
          TTYVTDisallocate = true;
        };
      };
    */

    services = {
      greetd = {
        enable = true;
        greeterManagesPlymouth = false;
        vt = 2;
        settings = {
          initial_session = {
            command = "uwsm start hyprland-uwsm.desktop";
            user = username;
          };
          default_session = {
            command = "${lib.getExe pkgs.greetd.tuigreet} --asterisks --remember --user-menu --cmd 'uwsm start hyprland-uwsm.desktop'";
            user = username;
          };
          terminal.switch = false;
        };
      };
      dbus = {
        enable = true;
        implementation = "broker";
      };
      pcscd.enable = true;
      # nautilus on non-gnome
      gvfs.enable = true;
    };
    programs.dconf.enable = true;
  };
}
