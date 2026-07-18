{
  pkgs,
  lib,
  osConfig,
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
        "SchemeContent"
        "SchemeExpressive"
        "SchemeFidelity"
        "SchemeFruitSalad"
        "SchemeMonochrome"
        "SchemeNeutral"
        "SchemeRainbow"
        "SchemeTonalSpot"
        "SchemeVibrant"
        "SchemeSmart"
      ];
      default = "SchemeSmart";
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
            pkgs.awww
            pkgs.zenity
            pkgs.sunwait
          ];
          runtimeEnv = {
            STATE = "/home/theaninova/.local/state/md3-evo";
            THEME_SERVICE_PATH = "${config.xdg.configHome}/systemd/user/theme-init.timer";
            FLAVOUR = toString cfg.flavour;
            LAT = "${toString cfg.auto-dark.lat}N";
            LON = "${toString cfg.auto-dark.lon}E";
          };
          text = builtins.readFile ./theme.sh;
        }
      );
    in
    lib.mkIf cfg.enable {
      home.packages = [
        pkgs.adw-gtk3
        pkgs.awww
        pkgs.tela-icon-theme
        pkgs.adwaita-icon-theme
        pkgs.adwaita-icon-theme-legacy
        pkgs.bibata-cursors
        pkgs.gnome-themes-extra
        theme-script
      ];
      gtk = {
        gtk3.extraCss = # css
          "@import './theme.css';";
        gtk4 = {
          theme.name = "Adwaita";
          extraCss = # css
            "@import './theme.css';";
        };
        theme = {
          name = "Adwaita";
        };
        iconTheme = {
          name = "Tela";
          package = pkgs.tela-icon-theme;
        };
      };
      qt.platformTheme.name = "qtct";

      systemd.user.services = {
        awww-daemon = {
          Unit = {
            Description = "Awww Daemon";
            After = [ "graphical-session.target" ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            ExecStart = "${pkgs.awww}/bin/awww-daemon";
            Restart = "always";
          };
        };
        theme-init = {
          Unit = {
            Description = "MD3 Evo Theme Init";
            After = [
              "graphical-session.target"
              "awww-daemon.service"
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
        settings.window_rule = [
          {
            name = "floating-zenity";
            match.class = "^(zenity)$";
            float = true;
          }
        ];
        extraConfig =
          # lua
          ''
            require("theme")
          '';
      };

      # TODO: include is coming in the next release
      /*
        xdg.configFile.niri-config = {
          enable = osConfig.programs.niri.enable;
          target = "niri/override.kdl";
          text = ''
            include "${config.xdg.configHome}/niri/config.kdl"
            include "${config.programs.matugen.settings.templates.niri.output_path}"
          '';
        };
        home.sessionVariables.NIRI_CONFIG = "${config.xdg.configHome}/niri/override.kdl";
      */

      programs = {
        kitty.extraConfig = ''
          include ${config.programs.matugen.settings.templates.kitty.output_path}
        '';

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
              version_check = false;
              source_color_index = 0;

              contrast = cfg.contrast;
              type = cfg.flavour;

              reload_apps_list = {
                waybar = config.programs.waybar.enable;
                dunst = config.services.dunst.enable;
              };

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

              import_json_files = [
                (pkgs.writeText "keywords.json" (
                  builtins.toJSON {
                    custom = {
                      inherit (cfg) flavour;
                      padding = toString cfg.padding;
                      double_padding = toString (cfg.padding * 2);
                      radius = toString cfg.radius;
                      transparency = toString cfg.transparency;
                      blur = toString cfg.blur;
                      contrast = toString cfg.contrast;
                      transparency_hex =
                        let
                          zeroPad = hex: if builtins.stringLength hex == 1 then "0${hex}" else hex;
                        in
                        zeroPad (lib.trivial.toHexString (builtins.floor (cfg.transparency * 255)));
                    };
                  }
                ))
              ];
            };

            templates =
              let
                gtk = pkgs.writeText "gtk4.css" (import ./gtk.nix);
                signal =
                  name: signal:
                  (pkgs.writeShellScript "kill-${name}" ''
                    pkill -${signal} -u "$USER" -x ${name} || :
                  '');
              in
              {
                nvim = {
                  input_path = ./nvim.vim;
                  output_path = "${config.xdg.configHome}/nvim/colors/md3-evo.vim";
                  post_hook = signal "nvim" "USR1";
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
              }
              // (lib.optionalAttrs osConfig.programs.niri.enable {
                niri = {
                  input_path = ./niri.kdl;
                  output_path = "${config.xdg.configHome}/niri/md3-evo.kdl";
                };
              })
              // (lib.optionalAttrs config.programs.kitty.enable {
                kitty = {
                  input_path = ./kitty.conf;
                  output_path = "${config.xdg.configHome}/kitty/theme.conf";
                  post_hook = signal ".kitty-wrapped" "USR1";
                };
              })
              // (lib.optionalAttrs osConfig.programs.hyprland.enable {
                hyprland = {
                  input_path = ./hyprland.lua;
                  output_path = "${config.xdg.configHome}/hypr/theme.lua";
                  post_hook = pkgs.writeShellScript "reload-hyprland-theme" ''
                    if command -v hyprctl &> /dev/null; then
                      hyprctl reload
                    fi
                  '';
                };
              })
              // (lib.optionalAttrs config.programs.waybar.enable {
                waybar = {
                  input_path = ./waybar.css;
                  output_path = "${config.xdg.configHome}/waybar/style.css";
                  post_hook = signal "waybar" "USR2";
                };
              })
              // (lib.optionalAttrs config.services.swaync.enable {
                swaync = {
                  input_path = ./swaync.css;
                  output_path = "${config.xdg.configHome}/swaync/style.css";
                  post_hook = pkgs.writeShellScript "reload-swaync" ''
                    if which swaync-client; then
                      swaync-client --reload-css
                    fi
                  '';
                };
              });
          };
        };
      };
    };
}
