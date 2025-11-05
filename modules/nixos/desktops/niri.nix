{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.desktops.niri;
in
{
  options.desktops.niri = {
    enable = lib.mkEnableOption "Enable a DE based on Niri";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    home-manager.users.${username} = {
      fonts.fontconfig.enable = true;
      home = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          GDK_BACKEND = "wayland";
          QT_QPA_PLATFORM = "wayland";
          SDL_VIDEODRIVER = "wayland";
        };

        packages = with pkgs; [
          xwayland-satellite
          # fonts
          noto-fonts
          # gnome packages
          qalculate-gtk
          evince
          baobab
          gnome.gvfs
          nautilus
          simple-scan
          eog
          ghex
          gnome-disk-utility
          # fixes
          xorg.xrandr
        ];

        pointerCursor = {
          gtk.enable = true;
          package = pkgs.capitaine-cursors;
          name = "capitaine-cursors";
        };
      };

      programs = {
        niri.settings = {
          binds = {
            "Mod+Left".action.focus-column-left = [ ];
            "Mod+Right".action.focus-column-right = [ ];
            "Mod+Up".action.focus-window-or-workspace-up = [ ];
            "Mod+Down".action.focus-window-or-workspace-down = [ ];

            "Mod+WheelScrollUp".action.focus-column-left = [ ];
            "Mod+WheelScrollDown".action.focus-column-right = [ ];

            "Mod+Shift+Left".action.move-column-left = [ ];
            "Mod+Shift+Right".action.move-column-right = [ ];
            "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = [ ];
            "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = [ ];

            "Mod+C".action.close-window = [ ];
            /*
              "Mod+M".action.spawn = [
                (pkgs.writeShellScript "qalculate" ''
                  if niri msg --json windows | jq -e 'any(.[]; .app_id == "qalculate-gtk")'; then
                    pkill qalculate-gtk
                  else
                    qalculate-gtk &
                  fi
                '')
              ];
            */

            "Mod+T".action.spawn = [ "kitty" ];

            "Mod+V".action.maximize-column = [ ];
            "Mod+D".action.fullscreen-window = [ ];
            "Mod+P".action.toggle-window-floating = [ ];

            "Mod+Shift+V".action.screenshot = [ ];
            # "Mod+Shift+C".action.pick-color = [ ];
          };
          overview.zoom = 0.8;
          window-rules = [
            {
              clip-to-geometry = true;
              tiled-state = true;
            }
            {
              matches = [ { app-id = "neovide"; } ];
              default-column-width.fixed = 1300;
            }
            {
              matches = [ { app-id = "firefox"; } ];
              default-column-width.fixed = 1500;
            }
            {
              matches = [ { app-id = "qalculate-gtk"; } ];
              open-floating = true;
              default-column-width.fixed = 1000;
              default-window-height.fixed = 800;
              default-floating-position = {
                x = 0;
                y = 0;
                relative-to = "bottom";
              };
            }
          ];
          layout = {
            always-center-single-column = true;
            center-focused-column = "always";
            focus-ring.enable = false;
            border.enable = false;
          };
          input = {
            mouse.accel-profile = "flat";
            warp-mouse-to-focus.enable = true;
            focus-follows-mouse = {
              enable = false;
              max-scroll-amount = "5%";
            };
          };
        };
      };
    };

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
            command = "${pkgs.niri}/bin/niri-session";
            user = username;
          };
          default_session = {
            command = "${lib.getExe pkgs.tuigreet} --asterisks --remember --user-menu --cmd '${pkgs.niri}/bin/niri-session'";
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
  };
}
