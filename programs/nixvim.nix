{ pkgs }:
let
  angular-ls = (import ../packages/node-packages { inherit pkgs; nodejs = pkgs.nodejs_18; })."@angular/language-server";
  nvim-treesitter-angular = (pkgs.vimUtils.buildVimPlugin {
    name = "nvim-treesitter-angular";
    src = pkgs.fetchFromGitHub {
      owner = "dlvandenberg";
      repo = "nvim-treesitter-angular";
      rev = "1d1b468180c2b2d40bf87a834a28297456e24825";
      hash = "sha256-z7jcJsrDdHE69VLO3V0nteZEvWxEN16vIOJDGJ01SJs=";
    };
  });
  darkman = (pkgs.vimUtils.buildVimPlugin {
    name = "darkman";
    src = pkgs.buildGoModule rec {
      pname = "darkman.nvim";
      version = "0.0.1";
      vendorHash = "sha256-HpyKzvKVN9hVRxxca4sdWRo91H32Ha9gxitr7Qg5MY8=";
      src = pkgs.fetchFromGitHub {
        owner = "4e554c4c";
        repo = "darkman.nvim";
        rev = "150aa63a13837c44abd87ff20d3a806321a17b2d";
        sha256 = "sha256-ssEYdM460I1rufjgh63CEkLi4K+bEWbwku/6gQbytno=";
      };
      postInstall = ''
        cp -r lua $out
      '';
    };
  });
in
  {
    enable = true;
    defaultEditor = true;

    options = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      signcolumn = "yes";

      undodir = { __raw = /* lua */ "os.getenv('HOME') .. '/.config/nvim/undodir'"; };
      undofile = true;

      scrolloff = 8;

      termguicolors = true;

      fillchars.eob = " ";
    };

    keymaps = [
      { key = "<leader>u"; mode = "n"; action = "<cmd>:UndotreeToggle<CR>"; }
      { key = "<leader>ft"; action = "<cmd>:Neotree toggle<CR>"; }
      { key = "<leader>s"; action = "<cmd>:SymbolsOutline<CR>"; }
    ];

    globals = {
      minimap_width = 10;
      minimap_auto_start = 1;
      minimap_auto_start_win_enter = 1;
      minimap_close_buftypes = [ "nofile" ];
      minimap_block_filetypes = [ "NvimTree" ];

      catppuccin_debug = true;

      mapleader = ";";
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    extraConfigVim = /* vim */ ''
      hi Normal guibg=NONE ctermbg=NONE
    '';

    extraConfigLua = /* lua */ ''
      require("scrollbar").setup()
      require("darkman").setup()
      require("symbols-outline").setup()

      local Terminal  = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",

        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })


      function _lazygit_toggle()
        lazygit:toggle()
      end

      vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
    '';

    colorschemes.catppuccin = {
      enable = true;
      transparentBackground = true;
      background = {
        dark = "frappe";
        light = "latte";
      };
      integrations.indent_blankline.colored_indent_levels = true;
    };

    plugins = {
      lualine = {
        enable = true;
        globalstatus = true;
        sectionSeparators = { left = ""; right = ""; };
        componentSeparators = { left = "┊"; right = "┊"; };
        sections = {
          lualine_a = [ { name = "mode"; separator = { right = ""; left = ""; }; icon = ""; } ];
          lualine_z = [ { name = "location"; separator = { right = ""; left = ""; }; } ];
        };
      };
      noice = {
        enable = true;
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        presets = {
          bottom_search = true; 
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
          lsp_doc_border = false;
        };
      };
      auto-save = {
        enable = true;
        triggerEvents = [ "FocusLost" "CursorHold" "BufLeave" ];
      };
      indent-blankline = {
        enable = true;
        indent.char = "▏";
      };
      illuminate.enable = true;
      rainbow-delimiters.enable = true;
      notify.enable = true;
      nvim-autopairs.enable = true;
      nvim-colorizer.enable = true;
      neo-tree = {
        enable = true;
        filesystem.filteredItems.visible = true;
        eventHandlers = {
          file_opened = /* lua */ ''
            function()
              require('neo-tree').close_all()
            end
          '';
        };
      };
      undotree.enable = true;
      toggleterm = {
        enable = true;
        openMapping = "<leader>t";
        direction = "vertical";
        size = 60;
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "git_files";
          "<leader>fa" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      treesitter = {
        enable = true;
        indent = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars ++ [
          (pkgs.tree-sitter.buildGrammar {
            language = "angular";
            version = "624ff10";
            src = pkgs.fetchFromGitHub {
              owner = "dlvandenberg";
              repo = "tree-sitter-angular";
              rev = "e316388ca6dcc728a5c521b4d63acecdeedab942";
              hash = "sha256-t/qLxBideSGP/x4dhDu8MvMnugIEhcBvYasUdUFisFI=";
            };
          })
        ];
      };

      none-ls.enable = true;
      lsp-format.enable = true;
      lsp = {
        enable = true;
        keymaps = {
          diagnostic = {
          };
        };
        enabledServers = [
          {
            name = "angularls";
            extraOptions = {
              cmd = ["${angular-ls}" "--stdio" "--tsProbeLocations" "${pkgs.nodePackages.typescript-language-server}" "--ngProbeLocations" "${angular-ls}"];
            };
          }
        ];
        servers = {
          html.enable = true;
          cssls.enable = true;
          svelte.enable = true; 
          eslint.enable = true;
          tsserver.enable = true;

          yamlls.enable = true;
          jsonls.enable = true;
          taplo.enable = true;

          rust-analyzer.enable = true;
          pylsp.enable = true;

          nixd.enable = true;
          bashls.enable = true;
        };
      };

      lspkind = {
        enable = true;
        mode = "symbol";
        cmp.after = /* lua */ ''
          function(entry, vim_item, kind)
            kind.kind = kind.kind .. " ";
            return kind
          end
        '';
      };
      nvim-cmp = {
        enable = true;
        mapping = { 
          "<C-n>" = /* lua */ "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";
          "<C-p>" = /* lua */ "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
          "<C-Space>" = /* lua */ "cmp.mapping.confirm({select = true})";
          "<C-Enter>" = /* lua */ "cmp.mapping.complete()";
        };
        sources = [
          { name = "path"; }
          { name = "nvim_lsp"; }
          { name = "npm"; }
          { name = "treesitter"; }
        ];
        formatting.fields = [ "kind" "abbr" "menu" ];
        window.completion.border = "rounded";
      };

      nix.enable = true;
    };

    extraPackages = [ angular-ls pkgs.nodePackages.typescript-language-server ];
    extraPlugins = with pkgs.vimPlugins; [
      nvim-treesitter-angular
      darkman
      nvim-scrollbar
      symbols-outline-nvim
    ];
  }
