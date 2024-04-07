{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.theme.base16;
in
{
  config = mkIf cfg.enable {
    programs.nixvim = {
      extraConfigLuaPre = ''
        require('flavours-colors')
      '';
      extraPlugins = [ pkgs.vimPlugins.base16-nvim ];
    };

    xdg.configFile."flavours/templates/nvim/templates/default.mustache".source = ./default.mustache;

    theme.base16.options.items = [
      {
        file = "${config.xdg.configHome}/nvim/lua/flavours-colors.lua";
        template = "nvim";
        #hook = "kill -SIGUSR1 $(pgrep kitty)";
        rewrite = true;
      }
    ];
  };
}
