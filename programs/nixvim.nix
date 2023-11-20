{ pkgs }:
{
  enable = true;
  
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
    { key = "<F9>"; mode = "n"; action = "<cmd>:UndotreeToggle<CR>"; }
  ];

  globals = {
    minimap_width = 10;
    minimap_auto_start = 1;
    minimap_auto_start_win_enter = 1;
  };

  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };

  extraConfigVim = ''
    hi Normal guibg=NONE ctermbg=NONE
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
    gitblame.enable = true;
    fidget.enable = true;
    indent-blankline = {
      enable = true;
      indent.char = "▏";
    };
    rainbow-delimiters.enable = true;
    nvim-autopairs.enable = true;
    illuminate.enable = true;
    nvim-colorizer.enable = true;
    undotree.enable = true;

    treesitter = {
      enable = true;
      indent = true;
    };

    none-ls.enable = true;
    lspsaga = {
      enable = true;
    };
    lsp-format.enable = true;
    lsp = {
      enable = true;
      keymaps = {
        diagnostic = {
        };
      };
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
        "<F7>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";
        "<F5>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
        "<F6>" = "cmp.mapping.confirm({select = true})";
      };
      sources = [
        { name = "buffer"; }
        { name = "path"; }
        { name = "nvim_lsp"; }
        { name = "npm"; }
      ];
    };

    nix.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    minimap-vim
  ];
}
