{ lib, config, ... }:
let
  cfg = config.presets.languages.cue;
in
{
  options.presets.languages.cue = {
    enable = lib.mkEnableOption "CUE";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.settings.formatters_by_ft.cue = [ "cue_fmt" ];
      lsp.servers.cue.enable = true;
    };
  };
}
