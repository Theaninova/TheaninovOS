{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.theme.md3-evo;
in
{
  options.theme.md3-evo = {
    enable = lib.mkEnableOption "the MD3-EVO theme";
    auto-dark = {
      enable = lib.mkEnableOption "Automatically switch between light and dark mode";
      lon = lib.mkOption {
        type = lib.types.float;
      };
      lat = lib.mkOption {
        type = lib.types.float;
      };
    };
    flavour = lib.mkOption {
      type = lib.types.enum [
        "content"
        "expressive"
        "fidelity"
        "fruit-salad"
        "monochrome"
        "neutral"
        "rainbow"
        "tonal-spot"
      ];
      default = "tonal-spot";
      description = "The flavour of the theme";
    };
    contrast = lib.mkOption {
      type = lib.types.numbers.between (-1) 1;
      default = 0;
      description = "Use a modified contrast";
    };
    transparency = lib.mkOption {
      type = lib.types.numbers.between 0 1;
      default = 0.9;
      description = "The transparency of apps";
    };
    radius = lib.mkOption {
      type = lib.types.ints.positive;
      default = 24;
      description = "The radius of the corners";
    };
    padding = lib.mkOption {
      type = lib.types.ints.positive;
      default = 12;
      description = "The padding of the windows";
    };
    blur = lib.mkOption {
      type = lib.types.ints.positive;
      default = 16;
      description = "The blur amount of windows";
    };
    semantic = {
      blend = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Blend the colors";
      };
      danger = lib.mkOption {
        type = lib.types.str;
        default = "#ff0000";
        description = "The color of danger";
      };
      warning = lib.mkOption {
        type = lib.types.str;
        default = "#ffff00";
        description = "The color of warning";
      };
      success = lib.mkOption {
        type = lib.types.str;
        default = "#00ff00";
        description = "The color of success";
      };
      info = lib.mkOption {
        type = lib.types.str;
        default = "#0000ff";
        description = "The color of info";
      };
    };
    syntax = {
      blend = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Blend the colors";
      };
      keywords = lib.mkOption {
        type = lib.types.str;
        default = "#ff8000";
        description = "The color of keywords";
      };
      functions = lib.mkOption {
        type = lib.types.str;
        default = "#0000ff";
        description = "The color of functions";
      };
      properties = lib.mkOption {
        type = lib.types.str;
        default = "#ff00ff";
        description = "The color of properties";
      };
      constants = lib.mkOption {
        type = lib.types.str;
        default = "#ff00ff";
        description = "The color of constants";
      };
      strings = lib.mkOption {
        type = lib.types.str;
        default = "#00ff00";
        description = "The color of variables";
      };
      numbers = lib.mkOption {
        type = lib.types.str;
        default = "#00ffff";
        description = "The color of numbers";
      };
      structures = lib.mkOption {
        type = lib.types.str;
        default = "#ffff00";
        description = "The color of structures";
      };
      types = lib.mkOption {
        type = lib.types.str;
        default = "#00ffff";
        description = "The color of types";
      };
    };
    ansi = {
      blend = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Blend the colors";
      };
      red = lib.mkOption {
        type = lib.types.str;
        default = "#ff0000";
        description = "The color of red";
      };
      green = lib.mkOption {
        type = lib.types.str;
        default = "#00ff00";
        description = "The color of green";
      };
      yellow = lib.mkOption {
        type = lib.types.str;
        default = "#ffff00";
        description = "The color of yellow";
      };
      orange = lib.mkOption {
        type = lib.types.str;
        default = "#ff8000";
        description = "The color of orange";
      };
      blue = lib.mkOption {
        type = lib.types.str;
        default = "#0000ff";
        description = "The color of blue";
      };
      magenta = lib.mkOption {
        type = lib.types.str;
        default = "#ff00ff";
        description = "The color of magenta";
      };
      cyan = lib.mkOption {
        type = lib.types.str;
        default = "#00ffff";
        description = "The color of cyan";
      };
    };
  };

  config =
    let
      theme-script = (
        pkgs.writeShellApplication {
          name = "theme";
          runtimeInputs = [
            pkgs.matugen
            pkgs.swww
            pkgs.zenity
            pkgs.sunwait
          ];
          text = ''
            WALLPAPER=${config.xdg.configHome}/matugen/wallpaper
            STATE=${config.xdg.stateHome}/md3-evo

            SCHEME=$(dconf read /org/gnome/desktop/interface/color-scheme)
            if [ "$SCHEME" = "'prefer-light'" ]; then
              MODE="light"
            else
              MODE="dark"
            fi

            if [ ! -d "$STATE" ]; then
              mkdir -p "$STATE"
            fi
            if [ -f "$STATE/mode" ]; then
              MODE=$(cat "$STATE/mode")
            fi

            if [ $# -eq 0 ]; then
              echo -e "\033[1mUsage:\033[0m mode|light|dark|auto|toggle|wallpaper"
              exit 1
            elif [ "$1" = "mode" ]; then
              echo -e "$MODE"
              exit 0
            elif [ "$1" = "wallpaper" ]; then
              if [ $# -eq 1 ]; then
                PICKED=$(zenity --file-selection --file-filter='Images | *.png *.jpg *.jpeg *.svg *.bmp *.gif')
                cp "$PICKED" "$WALLPAPER"
              else
                cp "$2" "$WALLPAPER"
              fi
            elif [ "$1" = "toggle" ]; then
              if [ "$MODE" = "light" ]; then
                MODE="dark"
              else
                MODE="light"
              fi
              echo "$MODE" > "$STATE/mode"
            elif [ "$1" = "light" ] || [ "$1" = "dark" ] || [ "$1" == "auto" ]; then
              MODE="$1"
              echo "$MODE" > "$STATE/mode"
            elif [ "$1" = "init" ]; then
              echo -e "\033[1mSetting up matugen\033[0m"
            else
              echo -e "\033[31mInvalid argument\033[0m"
              exit 1
            fi

            if [ ! -f $WALLPAPER ]; then
              echo -e "\033[31,1mNo wallpaper set\033[0m"
              exit 1
            fi


            THEME_SERVICE_PATH="${config.xdg.configHome}/systemd/user/theme-init.timer"
            if [ "$MODE" = "auto" ]; then
              TIME=$(sunwait poll ${builtins.toString cfg.auto-dark.lat}N ${builtins.toString cfg.auto-dark.lon}E || :)
              if [ "$TIME" = "DAY" ]; then
                MODE="light"
                NEXT=6
              else
                MODE="dark"
                NEXT=4
              fi
              NEXT=$(sunwait report ${builtins.toString cfg.auto-dark.lat}N ${builtins.toString cfg.auto-dark.lon}E | awk "/Daylight:/ {print \$$NEXT}")
              cat <<EOF | tee "$THEME_SERVICE_PATH" > /dev/null
            [Unit]
            Description=Next theme change timer

            [Timer]
            OnCalendar=*-*-* $(date -d "$NEXT today + 5 minutes" +'%H:%M'):00
            AccuracySec=1min

            [Install]
            WantedBy=timers.target
            EOF
            else
              rm -f "$THEME_SERVICE_PATH"
            fi
            systemctl --user daemon-reload &> /dev/null || :
            systemctl --user restart theme-init.timer &> /dev/null || :

            if [ "$MODE" = "light" ]; then
              GTK_THEME="adw-gtk3"
            else
              GTK_THEME="adw-gtk3-dark"
            fi

            matugen image "$WALLPAPER" --type scheme-${cfg.flavour} --contrast ${builtins.toString cfg.contrast} --mode "$MODE"
            sed -i "s/set background=dark/set background=$MODE/g" ${config.xdg.configHome}/nvim/colors/md3-evo.vim

            dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'"
            dconf write /org/gnome/desktop/interface/color-scheme "'prefer-$MODE'"

            if command -v hyprctl &> /dev/null; then
              hyprctl reload
            fi

            if which swaync-client; then
              swaync-client --reload-css
            fi

            for i in $(pgrep -u "$USER" -x nvim); do
              kill -USR1 "$i"
            done
          '';
        }
      );
    in
    lib.mkIf cfg.enable {
      home.packages = [
        pkgs.adw-gtk3
        pkgs.swww
        theme-script
      ];

      gtk = {
        gtk3.extraCss = # css
          "@import './theme.css';";
        gtk4.extraCss = # css
          "@import './theme.css';";
        iconTheme = {
          name = "Tela";
          package = pkgs.tela-icon-theme;
        };
      };
      qt.platformTheme.name = "qtct";

      systemd.user.services = {
        swww-daemon = {
          Unit = {
            Description = "Swww Daemon";
            After = [ "graphical-session.target" ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            ExecStart = "${pkgs.swww}/bin/swww-daemon";
            Restart = "always";
          };
        };
        theme-init = {
          Unit = {
            Description = "MD3 Evo Theme Init";
            After = [
              "graphical-session.target"
              "swww-daemon.service"
            ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            ExecStart = "${lib.getExe theme-script} init";
            Restart = "on-failure";
          };
        };
      };

      wayland.windowManager.hyprland = {
        settings = {
          windowrulev2 = [ "float,class:^(zenity)$" ];
          decoration = {
            inactive_opacity = 0.8;
            shadow = {
              enabled = true;
              range = 32;
              render_power = 8;
              color = "rgba(000000aa)";
              color_inactive = "rgba(00000011)";
            };
          };
          animations = {
            enabled = "yes";
            bezier = [
              "expoOut, 0.16, 1, 0.3, 1"
            ];
            animation = [
              "windowsIn, 1, 5, expoOut, slide bottom"
              "windows, 1, 5, expoOut, slide"
              "windowsOut, 1, 5, expoOut, slide bottom"
              "border, 1, 10, default"
              "fade, 1, 7, default"
              "fadeShadow, 1, 10, default"
              "fadeDim, 1, 10, default"
              "workspaces, 1, 6, default"
            ];
          };
        };
        extraConfig = ''
          source=./theme.conf
        '';
      };

      programs = {
        kitty = {
          extraConfig = ''
            include ${config.xdg.configHome}/kitty/theme.conf
          '';
        };

        nixvim = {
          opts.termguicolors = true;
          colorscheme = "md3-evo";
          autoCmd = [
            {
              event = [ "Signal" ];
              pattern = [ "SIGUSR1" ];
              command = # vim
                "colorscheme md3-evo";
              nested = true;
            }
          ];
          plugins.lualine.settings.options.theme.__raw = # lua
            "function() return vim.g.lualine_theme end";
        };
        matugen = {
          enable = true;
          settings = {
            config = {
              reload_apps = true;
              reload_apps_list = {
                kitty = config.programs.kitty.enable;
                waybar = config.programs.waybar.enable;
                dunst = config.services.dunst.enable;
              };

              set_wallpaper = true;
              wallpaper_tool = "Swww";

              custom_colors =
                let
                  mkColor = category: color: {
                    inherit (cfg.${category}) blend;
                    color = cfg.${category}.${color};
                  };
                in
                {
                  red = mkColor "ansi" "red";
                  green = mkColor "ansi" "green";
                  yellow = mkColor "ansi" "yellow";
                  orange = mkColor "ansi" "orange";
                  blue = mkColor "ansi" "blue";
                  magenta = mkColor "ansi" "magenta";
                  cyan = mkColor "ansi" "cyan";

                  keywords = mkColor "syntax" "keywords";
                  functions = mkColor "syntax" "functions";
                  constants = mkColor "syntax" "constants";
                  properties = mkColor "syntax" "properties";
                  strings = mkColor "syntax" "strings";
                  numbers = mkColor "syntax" "numbers";
                  structures = mkColor "syntax" "structures";
                  types = mkColor "syntax" "types";

                  danger = mkColor "semantic" "danger";
                  warning = mkColor "semantic" "warning";
                  success = mkColor "semantic" "success";
                  info = mkColor "semantic" "info";
                };

              custom_keywords = {
                inherit (cfg) flavour;
                padding = builtins.toString cfg.padding;
                double_padding = builtins.toString (cfg.padding * 2);
                radius = builtins.toString cfg.radius;
                transparency = builtins.toString cfg.transparency;
                blur = builtins.toString cfg.blur;
                contrast = builtins.toString cfg.contrast;
                transparency_hex =
                  let
                    zeroPad = hex: if builtins.stringLength hex == 1 then "0${hex}" else hex;
                  in
                  zeroPad (lib.trivial.toHexString (builtins.floor (cfg.transparency * 255)));
              };
            };

            templates =
              let
                gtk = pkgs.writeText "gtk4.css" (import ./gtk.nix);
              in
              {
                kitty = {
                  input_path = ./kitty.conf;
                  output_path = "${config.xdg.configHome}/kitty/theme.conf";
                };
                nvim = {
                  input_path = ./nvim.vim;
                  output_path = "${config.xdg.configHome}/nvim/colors/md3-evo.vim";
                };
                hyprland = {
                  input_path = ./hyprland.conf;
                  output_path = "${config.xdg.configHome}/hypr/theme.conf";
                };
                anyrun = {
                  input_path = ./anyrun.css;
                  output_path = "${config.xdg.configHome}/anyrun/theme.css";
                };
                gtk3 = {
                  input_path = gtk;
                  output_path = "${config.xdg.configHome}/gtk-3.0/theme.css";
                };
                gtk4 = {
                  input_path = gtk;
                  output_path = "${config.xdg.configHome}/gtk-4.0/theme.css";
                };
                vesktop = {
                  input_path = ./discord.css;
                  output_path = "${config.xdg.configHome}/vesktop/themes/matugen.theme.css";
                };
                waybar = {
                  input_path = ./waybar.css;
                  output_path = "${config.xdg.configHome}/waybar/style.css";
                };
                swaync = {
                  input_path = ./swaync.css;
                  output_path = "${config.xdg.configHome}/swaync/style.css";
                };
              };
          };
        };
      };
    };
}
