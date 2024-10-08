{ lib, config, ... }:
let
  cfg = config.presets.languages.dart;
in
{
  options.presets.languages.dart = {
    enable = lib.mkEnableOption "Dart";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.settings.formatters_by_ft.dart = [ "dart_format" ];
      lsp.servers.dartls.enable = true;
    };
  };
}
