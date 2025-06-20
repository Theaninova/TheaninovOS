{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.languages.css;
in
{
  options.presets.languages.css = {
    enable = lib.mkEnableOption "CSS";
    stylelint = lib.mkEnableOption "stylelint";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      none-ls = lib.mkIf cfg.stylelint {
        enable = true;
        sources = {
          diagnostics.stylelint.enable = true;
          formatting.stylelint.enable = true;
        };
      };
      lsp.servers.cssls.enable = true;
    };
    extraPackages = lib.mkIf cfg.stylelint [ pkgs.nodePackages.stylelint ];
  };
}
