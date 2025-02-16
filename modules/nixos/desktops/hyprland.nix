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
      /*
        greetd.serviceConfig = {
          Type = "idle";
          StandardInput = "tty";
          StandardOutput = "journal";
          StandardError = "journal";
          TTYReset = "yes";
          TTYVHangup = "no";
          TTYVTDisallocate = "no";
        };
      */
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
            ${pkgs.sudo}/bin/sudo -u ${username} --login ${
              lib.getExe (
                pkgs.writeShellApplication {
                  name = "start-hyprland";
                  text = ''
                    ${pkgs.kbd}/bin/chvt 2
                    exec ${pkgs.util-linux}/bin/agetty -o '-p -f -- \u' --noclear --autologin ${username} %I "$TERM" StandardOutput=null StandardError=journal
                  '';
                }
              )
            }
          '';
          aliases = [ "display-manager.service" ];
        };
      */
      /*
        "hyprtty" = {
          description = "Start Hyprland";
          conflicts = [ "getty@tty1.service" ];
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
          script = "-${pkgs.util-linux}/bin/agetty -o '-p -f -- \\u' --noclear --autologin ${username} %I $TERM StandardOutput=null StandardError=journal";
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
      seatd = {
        enable = true;
        user = username;
      };
      /*
        getty = {
          autologinUser = username;
          extraArgs = [ "--noclear" ];
        };
      */
      kmscon = {
        enable = true;
        hwRender = true;
      };
      greetd = {
        enable = true;
        greeterManagesPlymouth = false;
        #vt = 1;
        settings = {
          initial_session = {
            command = "uwsm start ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop" # > ${homeConfig.xdg.configHome}/uwsm.log 2> ${homeConfig.xdg.configHome}/uwsm.err"
            /*
              lib.getExe (
                pkgs.writeShellApplication {
                  name = "start-hyprland";
                  text = ''
                    chvt 1
                    exec uwsm start hyprland-uwsm.desktop > ${homeConfig.xdg.configHome}/uwsm.log 2> ${homeConfig.xdg.configHome}/uwsm.err
                  '';
                }
              )
            */
            ;
            user = username;
          };
          default_session = {
            command = "${lib.getExe pkgs.greetd.tuigreet} --asterisks --remember --user-menu --cmd 'uwsm start hyprland-uwsm.desktop'";
            user = username;
          };
          terminal = {
            #vt = lib.mkForce 2;
            #switch = false;
          };
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
