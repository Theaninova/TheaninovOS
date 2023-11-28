{pkgs}: let
  angular-ls =
    (import ../packages/node-packages {
      inherit pkgs;
      nodejs = pkgs.nodejs_18;
    })
    ."@angular/language-server";
  tree-sitter-angular = pkgs.tree-sitter.buildGrammar {
    language = "angular";
    version = "624ff10";
    src = pkgs.fetchFromGitHub {
      owner = "dlvandenberg";
      repo = "tree-sitter-angular";
      rev = "ddd64047c8ccc3dc2aff1082e4461ebc9210917d";
      hash = "sha256-wAbkrJ0MmNhE3qb34DQiju/mFIb7YCTyBUgVmP+iWQs=";
    };
  };
  darkman = pkgs.vimUtils.buildVimPlugin {
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
  };
in {
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

    undodir = {__raw = "os.getenv('HOME') .. '/.config/nvim/undodir'";};
    undofile = true;

    scrolloff = 8;

    termguicolors = true;

    updatetime = 50;

    fillchars.eob = " ";
  };

  keymaps = [
    {
      key = "<leader>u";
      mode = "n";
      action = "<cmd>:UndotreeToggle<CR>";
    }
    {
      key = "<leader>ft";
      action = "<cmd>:Neotree toggle<CR>";
    }
    {
      key = "<leader>s";
      action = "<cmd>:SymbolsOutline<CR>";
    }

    {
      key = "J";
      mode = "v";
      action = ":m '>+1<CR>gv=gv";
    }
    {
      key = "K";
      mode = "v";
      action = ":m '<-2<CR>gv=gv";
    }

    {
      key = "<C-d>";
      mode = "n";
      action = "<C-d>zz";
    }
    {
      key = "<C-u>";
      mode = "n";
      action = "<C-d>zz";
    }

    {
      key = "<leader>p";
      mode = "x";
      action = ''"_dP'';
    }
    {
      key = "<leader>p";
      mode = "n";
      action = ''"_dP'';
    }
    {
      key = "<leader>p";
      mode = "v";
      action = ''"_dP'';
    }
  ];

  globals = {
    minimap_width = 10;
    minimap_auto_start = 1;
    minimap_auto_start_win_enter = 1;
    minimap_close_buftypes = ["nofile"];
    minimap_block_filetypes = ["NvimTree"];

    catppuccin_debug = true;

    mapleader = ";";
  };

  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };

  extraConfigVim = ''
    hi Normal guibg=NONE ctermbg=NONE
  '';

  extraConfigLua = ''
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
      sectionSeparators = {
        left = "";
        right = "";
      };
      componentSeparators = {
        left = "┊";
        right = "┊";
      };
      sections = {
        lualine_a = [
          {
            name = "mode";
            separator = {
              right = "";
              left = "";
            };
            icon = "";
          }
        ];
        lualine_z = [
          {
            name = "location";
            separator = {
              right = "";
              left = "";
            };
          }
        ];
      };
    };
    auto-save = {
      enable = true;
      triggerEvents = ["FocusLost" "BufLeave"];
    };
    indent-blankline = {
      enable = true;
      indent.char = "▏";
    };
    illuminate.enable = true;
    nvim-autopairs.enable = true;
    nvim-colorizer.enable = true;
    copilot-vim.enable = true;
    neo-tree = {
      enable = true;
      filesystem.filteredItems.visible = true;
      eventHandlers = {
        file_opened = ''
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
      grammarPackages =
        pkgs.vimPlugins.nvim-treesitter.allGrammars
        ++ [tree-sitter-angular];
      nixvimInjections = true;
    };

    none-ls = {
      enable = true;
      sources = {
        code_actions = {
          eslint.enable = true;
          shellcheck.enable = true;
        };
        diagnostics = {
          eslint.enable = true;
          shellcheck.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          prettier.enable = true;
          rustfmt.enable = true;
          shfmt.enable = true;
          stylua.enable = true;
        };
      };
      onAttach = ''
        function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({async = false})
              end,
            })
          end
        end
      '';
    };
    lsp = {
      enable = true;
      keymaps = {diagnostic = {};};
      enabledServers = [
        {
          name = "angularls";
          extraOptions = {
            cmd = [
              "${angular-ls}"
              "--stdio"
              "--tsProbeLocations"
              "${pkgs.nodePackages.typescript-language-server}"
              "--ngProbeLocations"
              "${angular-ls}"
            ];
          };
        }
      ];
      servers = {
        html.enable = true;
        cssls.enable = true;
        svelte.enable = true;
        tsserver.enable = true;

        yamlls.enable = true;
        jsonls.enable = true;
        taplo.enable = true;

        rust-analyzer.enable = true;
        pylsp.enable = true;

        nixd.enable = true;
        lua-ls.enable = true;
        bashls.enable = true;
      };
    };

    lspkind = {
      enable = true;
      mode = "symbol";
      cmp.after = ''
        function(entry, vim_item, kind)
          kind.kind = kind.kind .. " ";
          return kind
        end
      '';
    };
    nvim-cmp = {
      enable = true;
      mapping = {
        "<C-n>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";
        "<C-p>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
        "<C-Space>" = "cmp.mapping.confirm({select = true})";
        "<C-Enter>" = "cmp.mapping.complete()";
      };
      sources = [
        {name = "path";}
        {name = "nvim_lsp";}
        {name = "npm";}
        {name = "treesitter";}
      ];
      formatting.fields = ["kind" "abbr" "menu"];
      window.completion.border = "rounded";
    };

    nix.enable = true;
  };

  extraPackages = [angular-ls pkgs.nodePackages.typescript-language-server];
  extraPlugins = with pkgs.vimPlugins; [
    vim-startuptime
    darkman
  ];
}
