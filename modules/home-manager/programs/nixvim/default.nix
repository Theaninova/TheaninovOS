{ pkgs }:
{
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
    harpoon.enable = true;
    lazygit.enable = true;
    mergetool.enable = true;
    trouble.enable = true;
    undotree.enable = true;
    base = {
      completion.enable = true;
      diagnostics.enable = true;
      find.enable = true;
      formatting = {
        enable = true;
        prettier = true;
      };
      spellcheck.enable = false;
      status-line.enable = true;
      syntax.enable = true;
      tree.enable = true;
    };
    languages = {
      angular.enable = true;
      c = {
        enable = true;
        cppcheck = true;
      };
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

  extraPlugins = [ pkgs.vimPlugins.tiny-inline-diagnostic-nvim ];
  extraConfigLua = ''
    require("tiny-inline-diagnostic").setup({
        preset = "modern",
        hi = {
          arrow = "LineNr",
          background = "LineNr",
        },
        options = {
            show_source = true,
            use_icons_from_diagnostic = true,
            add_messages = true,
            throttle = 0,
            softwrap = 30,
            multiple_diag_under_cursor = true,
            multilines = {
                enabled = true,
                always_show = true,
            },
            show_all_diags_on_cursorline = false,
            enable_on_insert = true,
            enable_on_select = true,
            severity = {
                vim.diagnostic.severity.ERROR,
                vim.diagnostic.severity.WARN,
                vim.diagnostic.severity.INFO,
                vim.diagnostic.severity.HINT,
            },
        },
    })
  '';
  diagnostics.virtual_text = false;

  plugins = {
    leap.enable = true;
    vim-surround.enable = true;
    which-key.enable = true;
    schemastore.enable = true;
    comment.enable = true;
    debugprint.enable = true;
    todo-comments.enable = true;
    treesitter-context = {
      enable = false; # TODO: looks weird with Neovide
      settings = {
        line_numbers = false;
      };
    };
    none-ls.settings.debug = true;

    lsp.servers = {
      html.enable = true;
      svelte.enable = true;

      dockerls.enable = true;

      yamlls.enable = true;
      jsonls.enable = true;
      taplo.enable = true;
    };

    copilot-lua = {
      enable = true;
      settings.suggestion.auto_trigger = true;
    };
  };
}
