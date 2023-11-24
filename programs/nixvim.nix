{ pkgs }:
let
  angular-ls = (import ../packages/node-packages { inherit pkgs; nodejs = pkgs.nodejs_18; })."@angular/language-server";
  nvim-treesitter-angular = (pkgs.vimUtils.buildVimPlugin {
    name = "nvim-treesitter-angular";
    src = pkgs.fetchFromGitHub {
      owner = "dlvandenberg";
      repo = "nvim-treesitter-angular";
      rev = "e852e68352f1eed8f098691a74fd057461379cfe";
      sha256 = "sha256-zSVKDWAUYoXjxxZIovx9BqGyjKMmtvlUhnKLiYE/RIk=";
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

    scrolloff = 8;

    termguicolors = true;

    fillchars.eob = " ";
  };

  keymaps = [
    { key = "<leader>u"; mode = "n"; action = "<cmd>:UndotreeToggle<CR>"; }
    { key = "<leader>t"; mode = "n"; action = "<cmd>:NvimTreeOpen<CR>"; }
  ];

  globals = {
    minimap_width = 10;
    minimap_auto_start = 1;
    minimap_auto_start_win_enter = 1;

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

  colorschemes.gruvbox = {
    enable = true;
    trueColor = true;
    bold = true;
    italics = true;
    undercurl = true;
    underline = true;
    transparentBg = true;
  };

  plugins = {
    lualine.enable = true;
    fidget.enable = true;
    auto-save.enable = true;
    indent-blankline = {
      enable = true;
      indent.char = "▏";
    };
    rainbow-delimiters.enable = true;
    nvim-autopairs.enable = true;
    nvim-colorizer.enable = true;
    nvim-tree = {
      enable = true;
      filters.dotfiles = true;
    };
    undotree.enable = true;
    toggleterm = {
      enable = true;
      openMapping = "<c-t>";
      direction = "horizontal";
    };

    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = "find_files";
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
            rev = "b13cf5ccc54805622db6505904bf60b80537f22a";
            sha256 = "sha256-tOEuWDarWQSNhS7A3ah3tKohbYCxw0QO/GJWEURAxpc=";
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

    nvim-cmp = {
      enable = true;
      mapping = { 
        "<F7>" = /* lua */ "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";
        "<F5>" = /* lua */ "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
        "<F6>" = /* lua */ "cmp.mapping.confirm({select = true})";
      };
      sources = [
        { name = "path"; }
        { name = "nvim_lsp"; }
        { name = "npm"; }
      ];
    };

    nix.enable = true;
  };

  extraPackages = [ angular-ls pkgs.nodePackages.typescript-language-server ];
  extraPlugins = with pkgs.vimPlugins; [
    minimap-vim
    nvim-treesitter-angular
  ];
}
