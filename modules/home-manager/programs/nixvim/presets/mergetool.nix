{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.mergetool;
in
{
  options.presets.mergetool = {
    enable = lib.mkEnableOption "Mergetool";
  };

  config = lib.mkIf cfg.enable {
    globals = {
      mergetool_layout = "mr";
      mergetool_prefer_revision = "local";
    };
    extraPlugins = [ pkgs.vimPlugins.vim-mergetool ];
  };
}
