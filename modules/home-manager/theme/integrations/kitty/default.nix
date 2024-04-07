{ config, lib, ... }:

with lib;

let
  cfg = config.theme.base16;
in
{
  config = mkIf cfg.enable {
    programs.kitty.extraConfig = ''
      include ./current-theme.conf
    '';

    xdg.configFile."flavours/templates/kitty/templates/default.mustache".source = ./default.mustache;

    theme.base16.options.items = [
      {
        file = "${config.xdg.configHome}/kitty/current-theme.conf";
        template = "kitty";
        hook = "kill -SIGUSR1 $(pgrep kitty)";
        rewrite = true;
      }
    ];
  };
}
