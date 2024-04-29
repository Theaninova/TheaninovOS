{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib;

let
  cfg = config.theming.matugen;
  homeCfg = config.home-manager.users.${username};
in
{
  options.theming.matugen = {
    enable = mkEnableOption "Enable dynamic theming through matugen";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [
        pkgs.adw-gtk3
        pkgs.matugen
        (pkgs.writeShellApplication {
          name = "theme";
          runtimeInputs = [
            pkgs.matugen
            pkgs.swww
            pkgs.gnome.zenity
          ];
          text = ''
            WALLPAPER=${homeCfg.xdg.configHome}/matugen/wallpaper

            SCHEME=$(dconf read /org/gnome/desktop/interface/color-scheme)
            if [ "$SCHEME" = "'prefer-light'" ]; then
              MODE="light"
            else
              MODE="dark"
            fi

            if [ $# -eq 0 ]; then
              echo -e "\033[1mUsage:\033[0m mode|light|dark|toggle|wallpaper"
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
            elif [ "$1" = "light" ] || [ "$1" = "dark" ]; then
              MODE="$1"
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

            if [ "$MODE" = "light" ]; then
              GTK_THEME="adw-gtk3"
            else
              GTK_THEME="adw-gtk3-dark"
            fi

            matugen image "$WALLPAPER" --mode "$MODE"
            sed -i "s/set background=dark/set background=$MODE/g" ${homeCfg.xdg.configHome}/nvim/colors/matugen.vim

            dconf write /org/gnome/desktop/interface/gtk-theme "'$GTK_THEME'"
            dconf write /org/gnome/desktop/interface/color-scheme "'prefer-$MODE'"

            if command -v hyprctl &> /dev/null; then
              hyprctl reload
            fi

            for i in $(pgrep -u "$USER" -x nvim); do
              kill -USR1 "$i"
            done
          '';
        })
      ];
    };

    home-manager.users.${username} = {
      programs.kitty.extraConfig = ''
        include ${homeCfg.xdg.configHome}/kitty/theme.conf
      '';

      gtk = {
        gtk3.extraCss = "@import './theme.css';";
        gtk4.extraCss = "@import './theme.css';";
      };

      xdg.configFile."matugen/config.toml".source = (pkgs.formats.toml { }).generate "matugen" {
        config = {
          reload_apps = true;
          reload_apps_list = {
            kitty = homeCfg.programs.kitty.enable;
            waybar = false;
            dunst = homeCfg.services.dunst.enable;
          };

          set_wallpaper = true;
          wallpaper_tool = "Swww";

          custom_colors = {
            red = "#ff0000";
            green = "#00ff00";
            yellow = "#ffff00";
            orange = "#ff8000";
            blue = "#0000ff";
            magenta = "#ff00ff";
            cyan = "#00ffff";

            warn = {
              color = "#ffff00";
              blend = false;
            };
            ok = {
              color = "#00ff00";
              blend = false;
            };
          };
        };

        templates = {
          kitty = {
            input_path = ./kitty.conf;
            output_path = "${homeCfg.xdg.configHome}/kitty/theme.conf";
          };
          nvim = {
            input_path = ./nvim.vim;
            output_path = "${homeCfg.xdg.configHome}/nvim/colors/matugen.vim";
          };
          hyprland = {
            input_path = ./hyprland.conf;
            output_path = "${homeCfg.xdg.configHome}/hypr/theme.conf";
          };
          anyrun = {
            input_path = ./anyrun.css;
            output_path = "${homeCfg.xdg.configHome}/anyrun/theme.css";
          };
          gtk3 = {
            input_path = ./gtk.css;
            output_path = "${homeCfg.xdg.configHome}/gtk-3.0/theme.css";
          };
          gtk4 = {
            input_path = ./gtk.css;
            output_path = "${homeCfg.xdg.configHome}/gtk-4.0/theme.css";
          };
          vesktop = {
            input_path = ./discord.css;
            output_path = "${homeCfg.xdg.configHome}/vesktop/themes/matugen.theme.css";
          };
        };
      };
    };
  };
}
