{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.languages.js;
in
{
  options.presets.languages.js = {
    enable = lib.mkEnableOption "JS";
    eslint = lib.mkEnableOption "ESLint";
    npm = lib.mkEnableOption "NPM package completion";
  };

  config = lib.mkIf cfg.enable {
    extraConfigLua =
      lib.mkIf cfg.npm # lua
        ''
          require("cmp-npm").setup({})
        '';
    plugins = {
      lspkind = lib.mkIf cfg.npm {
        cmp.after = # lua
          ''
            function(entry, vim_item, kind)
              if entry.source.name == "npm" then
                kind.kind = ""
                kind.kind_hl_group = "CmpItemKindNpm"
              end
              kind.kind = kind.kind .. " "
              return kind
            end
          '';
      };
      cmp.settings.sources = lib.mkIf cfg.npm [
        {
          name = "npm";
          keywordLength = 4;
          priority = 10;
        }
      ];
      lsp.servers = {
        ts-ls.enable = true;
        eslint.enable = lib.mkIf cfg.eslint true;
      };
    };
    extraPackages = [ pkgs.nodePackages.typescript-language-server ];
  };
}
