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
    environment.systemPackages = with pkgs; [
      matugen
      swww
    ];

    home-manager.users.${username} = {
      programs.kitty.extraConfig = ''
        include ${homeCfg.xdg.configHome}/kitty/theme.conf
      '';

      xdg.configFile."matugen/config.toml".source = (pkgs.formats.toml { }).generate "matugen" {
        config = {
          reload_apps = true;
          reload_apps_list = {
            kitty = true;
            gtk_theme = true;
            waybar = false;
            dunst = false;
          };

          set_wallpaper = true;
          wallpaper_tool = "Swww";

          colors_to_harmonize = {
            red = "#ff0000";
            green = "#00ff00";
            yellow = "#ffff00";
            blue = "#0000ff";
            magenta = "#ff00ff";
            cyan = "#00ffff";
            bright_red = "#ff9999";
            bright_green = "#99ff99";
            bright_yellow = "#ffff99";
            bright_blue = "#9999ff";
            bright_magenta = "#ff99ff";
            bright_cyan = "#99ffff";
          };
        };

        templates = {
          kitty = {
            input_path = ./kitty.conf;
            output_path = "${homeCfg.xdg.configHome}/kitty/theme.conf";
          };
        };
      };
    };
  };
}
