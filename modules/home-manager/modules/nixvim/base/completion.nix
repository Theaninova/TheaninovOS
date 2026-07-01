{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.base.completion;
in
{
  options.presets.base.completion = {
    enable = lib.mkEnableOption "completion";
    copilot = lib.mkEnableOption "Copilot";
    ollama = lib.mkEnableOption "Ollama";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      luasnip.enable = true;
      lspkind = {
        enable = true;
        settings.mode = "symbol_text";
      };
      lualine.settings.sections.lualine_x = lib.mkIf cfg.ollama (
        lib.mkBefore [
          { __unkeyed-1.__raw = "require('minuet.lualine')"; }
        ]
      );
      copilot-lua = lib.mkIf cfg.copilot {
        enable = true;
        settings.suggestion.auto_trigger = true;
        lazyLoad = {
          enable = true;
          settings.event = [ "InsertEnter" ];
        };
      };
      minuet = lib.mkIf cfg.ollama {
        enable = true;
        settings = {
          provider = "openai_fim_compatible";
          n_completions = 1;
          context_window = 2048;
          throttle = 0;
          debounce = 0;
          provider_options.openai_fim_compatible = {
            api_key = "TERM";
            name = "Llama.cpp";
            end_point = "http://localhost:8012/v1/completions";
            model = "PLACEHOLDER";
            optional = {
              max_tokens = 56;
              top_p = 0.9;
            };
            # Llama.cpp does not support the `suffix` option in FIM completion.
            # Therefore, we must disable it and manually populate the special
            # tokens required for FIM completion.
            template = {
              prompt.__raw = ''
                function(context_before_cursor, context_after_cursor, _)
                      return '<|fim_prefix|>'
                          .. context_before_cursor
                          .. '<|fim_suffix|>'
                          .. context_after_cursor
                          .. '<|fim_middle|>'
                end
              '';
              suffix = false;
            };
          };
          cmp.enable_auto_complete = false;
          blink.enable_auto_complete = false;
          lsp.completion.enable = false;
          virtualtext = {
            auto_trigger_ft = [ "*" ];
            keymap = {
              # TODO: keymap
            };
          };
        };
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
            completion = {
              border = "solid";
              zindex = 10;
            };
            documentation = {
              border = "solid";
              zindex = 9;
            };
          };
        };
      };
    };
  };
}
