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
    extraConfigLua =
      lib.mkIf cfg.ollama
        #lua
        ''
          require('minuet').setup({
            provider = 'openai_fim_compatible',
            n_completions = 1,
            context_window = 1024,
            provider_options = {
              openai_fim_compatible = {
                api_key = 'TERM',
                name = 'Ollama',
                end_point = 'http://localhost:11434/v1/completions',
                model = 'deepseek-coder-v2:16b',
                optional = {
                  max_tokens = 56,
                  stop = { '\n' },
                  top_p = 0.9,
                },
              },
            },
            virtualtext = {
              show_on_completion_menu = true,
              auto_trigger_ft = { "*" },
              keymap = {
                accept = '<A-l>',
              },
            },
            throttle = 0,
            debounce = 0,
          })
        '';
    plugins = {
      luasnip.enable = true;
      lspkind = {
        enable = true;
        mode = "symbol_text";
      };
      lualine.settings.sections.lualine_x = lib.mkIf cfg.ollama (
        lib.mkBefore [
          { __unkeyed-1.__raw = "require('minuet.lualine')"; }
        ]
      );
      copilot-lua = lib.mkIf cfg.copilot {
        enable = true;
        settings.suggestion.auto_trigger = true;
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
              zindex = 10;
            };
          };
        };
      };
    };
    extraPlugins = lib.mkIf cfg.ollama [ pkgs.vimPlugins.minuet-ai-nvim ];
  };
}
