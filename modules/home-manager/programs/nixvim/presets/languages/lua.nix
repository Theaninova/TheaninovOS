{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.languages.lua;
in
{
  options.presets.languages.lua = {
    enable = lib.mkEnableOption "Lua";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.settings.formatters_by_ft.lua = [ "stylua" ];
      lsp.servers.lua-ls.enable = true;
    };
    extraPackages = [ pkgs.stylua ];
  };
}
