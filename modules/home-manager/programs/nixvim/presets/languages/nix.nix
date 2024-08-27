{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.languages.nix;
in
{
  options.presets.languages.nix = {
    enable = lib.mkEnableOption "Nix";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
      lsp.servers.nil-ls.enable = true;
      nix.enable = true;
    };
    extraPackages = [ pkgs.nixfmt-rfc-style ];
  };
}
