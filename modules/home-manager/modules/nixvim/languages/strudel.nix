{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.languages.strudel;
in
{
  options.presets.languages.strudel = {
    enable = lib.mkEnableOption "Strudel";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      strudel = {
        enable = true;
        lazyLoad = {
          enable = true;
          settings.ft = [ "strudel" ];
        };
      };
      web-devicons.customIcons = {
        str = {
          icon = " ";
          color = "#34E2E1";
          cterm_color = "14";
          name = "Strudel";
        };
      };
    };
  };
}
