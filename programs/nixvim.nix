{ pkgs }:
let
  angular-ls = (import ../packages/node-packages { inherit pkgs; nodejs = pkgs.nodejs_18; })."@angular/language-server";
  nvim-treesitter-angular = (pkgs.vimUtils.buildVimPlugin {
    name = "nvim-treesitter-angular";
    src = pkgs.fetchFromGitHub {
      owner = "dlvandenberg";
      repo = "nvim-treesitter-angular";
      rev = "7549872eb34934c5bc4f4df2ca71196755adfb1c";
      hash = "sha256-fayRXogWBeV9jDmjXs/u6ULlbCziKIL26pKKh9QJzf8=";
    };
  });
  tree-sitter-angular = (pkgs.tree-sitter.buildGrammar {
    language = "angular";
    version = "624ff10";
    src = pkgs.fetchFromGitHub {
      owner = "dlvandenberg";
      repo = "tree-sitter-angular";
      rev = "e0d7582e1ebbcf6136cfcfb22a37e20f4562acba";
      hash = "sha256-ADOlhAUidmRKCpDxmo70ZYHgtUIwxrfy0ucACfjkhlQ=";
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

      updatetime = 50;

      fillchars.eob = " ";
    };

    keymaps = [
      { key = "<leader>u"; mode = "n"; action = "<cmd>:UndotreeToggle<CR>"; }
      { key = "<leader>ft"; action = "<cmd>:Neotree toggle<CR>"; }
      { key = "<leader>s"; action = "<cmd>:SymbolsOutline<CR>"; }

      { key = "J"; mode = "v"; action = ":m '>+1<CR>gv=gv"; }
      { key = "K"; mode = "v"; action = ":m '<-2<CR>gv=gv"; }

      { key = "<C-d>"; mode = "n"; action = "<C-d>zz"; }
      { key = "<C-u>"; mode = "n"; action = "<C-d>zz"; }

      { key = "<leader>p"; mode = "x"; action = "\"_dP"; }
      { key = "<leader>p"; mode = "n"; action = "\"_dP"; }
      { key = "<leader>p"; mode = "v"; action = "\"_dP"; }
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
    require("darkman").setup()

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
      auto-save = {
        enable = true;
        triggerEvents = [ "FocusLost" "CursorHold" "BufLeave" ];
      };
      indent-blankline = {
        enable = true;
        indent.char = "▏";
      };
      illuminate.enable = true;
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
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars ++ [tree-sitter-angular];
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
      vim-startuptime
      darkman
    ];
  }
