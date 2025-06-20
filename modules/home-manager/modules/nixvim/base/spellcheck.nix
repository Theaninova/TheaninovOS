{
  lib,
  config,
  hmConfig,
  ...
}:
let
  cfg = config.presets.base.spellcheck;
in
{
  options.presets.base.spellcheck = {
    enable = lib.mkEnableOption "Spellcheck";
  };

  config = lib.mkIf cfg.enable {
    plugins.lsp.servers.harper_ls = {
      enable = true;
      settings = {
        userDictPath = "${hmConfig.xdg.configHome}/harper-user-dictionary.txt";
      };
    };
  };
}
