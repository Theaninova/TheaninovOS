{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.languages.python;
in
{
  options.presets.languages.python = {
    enable = lib.mkEnableOption "Python";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.formattersByFt.python = [ "black" ];
      lsp.servers.pylsp.enable = true;
    };
    extraPackages = [ pkgs.black ];
  };
}
