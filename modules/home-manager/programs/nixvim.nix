{ ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;

    opts = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      signcolumn = "yes";

      scrolloff = 12;

      hlsearch = false;
      incsearch = true;

      ignorecase = true;
      smartcase = true;

      updatetime = 50;

      fillchars.eob = " ";
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    globals.mapleader = ";";

    presets = {
      auto-save.enable = true;
      auto-format.enable = true;
      lazygit.enable = true;
      mergetool.enable = true;
      undotree.enable = true;
      aerial.enable = true;
      base = {
        completion = {
          enable = true;
          copilot = true;
        };
        diagnostics.enable = true;
        coverage.enable = false;
        find.enable = true;
        formatting = {
          enable = true;
          prettier = true;
        };
        spellcheck.enable = true;
        status-line.enable = true;
        syntax.enable = true;
        tree.enable = true;
      };
      languages = {
        c.enable = true;
        css = {
          enable = true;
          stylelint = true;
        };
        dart.enable = true;
        js = {
          enable = true;
          eslint = true;
          npm = true;
        };
        lua.enable = true;
        nix.enable = true;
        python.enable = true;
        rust.enable = true;
        shell.enable = true;
        svelte.enable = true;
      };
      remaps = {
        half-page-scroll.enable = true;
        no-accidental-macro.enable = true;
        paste-keep-buffer.enable = true;
        wrapped-line-nav.enable = true;
      };
    };

    /*
            keymaps = [
              {
                key = "s";
                mode = [
                  "n"
                  "x"
                  "o"
                ];
                action.__raw = "function() require('flash').jump() end";
                options.desc = "Flash";
              }
              {
                key = "S";
                mode = [
                  "n"
                  "x"
                  "o"
                ];
                action.__raw = "function() require('flash').treesitter() end";
                options.desc = "Flash Treesitter";
              }
              {
                key = "r";
                mode = "o";
                action.__raw = "function() require('flash').remote() end";
                options.desc = "Remote Flash";
              }
              {
                key = "R";
                mode = [
                  "o"
                  "x"
                ];
                action.__raw = "function() require('flash').treesitter_search() end";
                options.desc = "Treesitter Search";
              }
              {
                key = "<c-s>";
                mode = [
                  "c"
                ];
                action.__raw = "function() require('flash').toggle() end";
                options.desc = "Toggle Flash Search";
              }
            ];
      vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
      vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
    */
    keymaps = [
      {
        key = "s";
        mode = [
          "n"
          "x"
          "o"
        ];
        action.__raw = ''
          function()
            require('leap').leap({
              windows = { vim.api.nvim_get_current_win() },
              inclusive = true
            })
          end
        '';
        options.desc = "Leap";
      }
      {
        key = "R";
        mode = [
          "x"
          "o"
        ];
        action.__raw = ''
          function ()
            require('leap.treesitter').select {
              -- To increase/decrease the selection in a clever-f-like manner,
              -- with the trigger key itself (vRRRRrr...). The default keys
              -- (<enter>/<backspace>) also work, so feel free to skip this.
              opts = require('leap.user').with_traversal_keys('R', 'r')
            }
          end
        '';
      }
    ];

    plugins = {
      which-key.enable = true;
      schemastore.enable = true;
      todo-comments.enable = true;
      origami.enable = false;
      nvim-surround.enable = true;
      fidget.enable = true;
      leap = {
        enable = true;
      };
      /*
        flash = {
          enable = true;
          settings = {
            label = {
              exclude = "jJxXqQ";
              rainbow.enabled = true;
            };
            search = {
              mode = "exact";
              trigger = ";";
            };
          };
        };
      */
      treesitter-context = {
        enable = false; # TODO: looks weird with Neovide
        settings.line_numbers = false;
      };

      lsp.servers = {
        html.enable = true;
        svelte.enable = true;

        dockerls.enable = true;

        yamlls.enable = true;
        jsonls.enable = true;
        taplo.enable = true;
      };
    };
  };
}
