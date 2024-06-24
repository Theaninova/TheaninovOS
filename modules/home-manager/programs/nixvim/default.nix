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
      status-line.enable = true;
      syntax.enable = true;
      tree.enable = true;
    };
    languages = {
      angular.enable = true;
      c.enable = true;
      css = {
        enable = true;
        stylelint = true;
      };
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
    };
    remaps = {
      half-page-scroll.enable = true;
      no-accidental-macro.enable = true;
      paste-keep-buffer.enable = true;
    };
  };

  plugins = {
    leap.enable = true;
    surround.enable = true;
    which-key.enable = true;
    schemastore.enable = true;

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
      suggestion.autoTrigger = true;
    };
  };
}
