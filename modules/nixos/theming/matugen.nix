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
            gtk_theme = false;
            waybar = false;
            dunst = false;
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
        };
      };
    };
  };
}
