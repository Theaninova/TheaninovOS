{
  lib,
  config,
  ...
}:
let
  cfg = config.presets.languages.typst;
in
{
  options.presets.languages.typst = {
    enable = lib.mkEnableOption "Typst";
  };

  config = lib.mkIf cfg.enable {
    lsp.servers.tinymist.enable = true;
    plugins.typst-preview = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.ft = [ "typst" ];
      };
    };
  };
}
