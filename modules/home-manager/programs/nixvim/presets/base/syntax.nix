{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.base.syntax;
in
{
  options.presets.base.syntax = {
    enable = lib.mkEnableOption "syntax highlighting";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      treesitter = {
        enable = true;
        settings = {
          highlight = {
            additional_vim_regex_highlighting = true;
            enable = true;
          };
          indent.enable = true;
        };
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        nixvimInjections = true;
      };
      indent-blankline = {
        enable = lib.mkDefault true;
        settings = {
          indent.char = "▏";
          scope.show_start = false;
        };
      };
      illuminate.enable = lib.mkDefault true;
      nvim-autopairs.enable = lib.mkDefault true;
      nvim-colorizer.enable = lib.mkDefault true;
      ts-autotag = {
        enable = lib.mkDefault true;
        settings.opts.enable_close_on_slash = lib.mkDefault true;
      };
    };
  };
}
