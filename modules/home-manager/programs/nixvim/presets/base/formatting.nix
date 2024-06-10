{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.base.formatting;
in
{
  options.presets.base.formatting = {
    enable = lib.mkEnableOption "formatting";
    prettier = lib.mkEnableOption "prettier formatter";
  };

  config = lib.mkIf cfg.enable {
    plugins.conform-nvim = {
      enable = true;
      formattersByFt = lib.mkIf cfg.prettier {
        javascript = [ "prettierd" ];
        markdown = [ "prettierd" ];
        typescript = [ "prettierd" ];
        json = [ "prettierd" ];
        yaml = [ "prettierd" ];
        html = [ "prettierd" ];
        angular = [ "prettierd" ];
        css = [ "prettierd" ];
        scss = [ "prettierd" ];
        less = [ "prettierd" ];
        svelte = [ "prettierd" ];
      };
    };
    extraPackages = lib.mkIf cfg.prettier [ pkgs.prettierd ];
  };
}
