{ ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    nixpkgs.useGlobalPackages = true;

    performance.byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };

    extraConfigLuaPre = ''
      require('vim._core.ui2').enable()
    '';

    opts = {
      number = true;
      relativenumber = true;

      cmdheight = 0;

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

      winborder = "solid";
      pumborder = "solid";
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    globals.mapleader = ";";

    presets = {
      auto-save.enable = true;
      auto-session.enable = true;
      auto-format.enable = true;
      lazygit.enable = true;
      mergetool.enable = true;
      undotree.enable = true;
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
        leap.enable = true;
        spellcheck.enable = true;
        status-line.enable = true;
        syntax.enable = true;
        tabs.enable = true;
        yazi.enable = true;
      };
      languages = {
        c.enable = true;
        css = {
          enable = true;
          stylelint = true;
        };
        cue.enable = true;
        dart.enable = true;
        godot.enable = true;
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
        strudel.enable = true;
        svelte.enable = true;
      };
      remaps = {
        half-page-scroll.enable = true;
        no-accidental-macro.enable = true;
        paste-keep-buffer.enable = true;
        wrapped-line-nav.enable = true;
      };
    };

    plugins = {
      which-key.enable = true;
      schemastore.enable = true;
      todo-comments.enable = true;
      origami.enable = false;
      nvim-surround.enable = true;
      fidget.enable = true;
      gitsigns.enable = true;
      treesitter-context = {
        enable = false; # TODO: looks weird with Neovide
        settings.line_numbers = false;
      };

      lsp.servers = {
        html.enable = true;
        svelte.enable = true;
        buf_ls.enable = true;
        glsl_analyzer.enable = true;

        dockerls.enable = true;

        yamlls = {
          enable = true;
          settings.customTags = [
            "!if mapping"
            "!any sequence"
            "!not scalar"
            "!flat sequence"
            "!repeat mapping"
            "!param scalar"
            "!macro mapping"
          ];
        };
        jsonls.enable = true;
        taplo.enable = true;
      };
    };
  };
}
