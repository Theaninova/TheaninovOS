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
          GDK_BACKEND = "wayland,x11,*";
          QT_QPA_PLATFORM = "wayland;xcb";
          SDL_VIDEODRIVER = "wayland";
        };

        packages = with pkgs; [
          xwayland-satellite
          # fonts
          noto-fonts
          # gnome packages
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
        dankMaterialShell = {
          enable = true;
          niri = {
            enableSpawn = true;
            enableKeybinds = false;
          };
        };
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
            "Mod+M".action.center-window = [ ];

            "Mod+T".action.spawn = [ "kitty" ];

            "Mod+V".action.maximize-column = [ ];
            "Mod+P".action.fullscreen-window = [ ];

            "Mod+Space".action.spawn = [
              "dms"
              "ipc"
              "spotlight"
              "toggle"
            ];
            "Mod+MouseMiddle".action.toggle-overview = [ ];
          };
          window-rules = [
            {
              geometry-corner-radius = {
                top-left = 24.0;
                top-right = 24.0;
                bottom-left = 24.0;
                bottom-right = 24.0;
              };
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

    programs.dankMaterialShell.greeter = {
      enable = true;
      compositor.name = "niri";
      configHome = "/home/${username}";
    };

    services = {
      kmscon = {
        enable = true;
        hwRender = true;
      };
    };
  };
}
