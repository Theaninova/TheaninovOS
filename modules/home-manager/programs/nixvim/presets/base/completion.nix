{ lib, config, ... }:
let
  cfg = config.presets.base.completion;
in
{
  options.presets.base.completion = {
    enable = lib.mkEnableOption "completion";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      luasnip.enable = true;
      lspkind = {
        enable = true;
        mode = "symbol_text";
      };
      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-n>" = # lua
              "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";
            "<C-p>" = # lua
              "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
            "<C-y>" = # lua
              "cmp.mapping.confirm({select = true})";
            "<C-Enter>" = # lua
              "cmp.mapping.complete()";
          };
          sources = [
            { name = "path"; }
            { name = "luasnip"; }
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "nvim_lsp_document_symbol"; }
          ];
          formatting.fields = [
            "abbr"
            "kind"
          ];
          snippet.expand = # lua
            "function(args) require('luasnip').lsp_expand(args.body) end";
          window = {
            completion.border = "rounded";
            documentation.border = "rounded";
          };
        };
      };
    };
  };
}
