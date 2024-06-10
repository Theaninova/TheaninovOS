{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.languages.shell;
in
{
  options.presets.languages.shell = {
    enable = lib.mkEnableOption "Shell/Bash";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.formattersByFt.sh = [ "shfmt" ];
      lsp.servers.bashls.enable = true;
    };
    extraPackages = [ pkgs.shfmt ];
  };
}
