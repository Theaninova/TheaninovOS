{pkgs}: let
  angular-ls =
    (import ../packages/node-packages {
      inherit pkgs;
      nodejs = pkgs.nodejs_18;
    })
    ."@angular/language-server";
  /*
    *tree-sitter-angular = pkgs.tree-sitter.buildGrammar {
    language = "angular";
    version = "624ff10";
    src = pkgs.fetchFromGitHub {
      owner = "dlvandenberg";
      repo = "tree-sitter-angular";
      rev = "ddd64047c8ccc3dc2aff1082e4461ebc9210917d";
      hash = "sha256-wAbkrJ0MmNhE3qb34DQiju/mFIb7YCTyBUgVmP+iWQs=";
    };
  };
  */
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
  lualine-so-fancy = pkgs.vimUtils.buildVimPlugin {
    name = "lualine-so-fancy";
    version = "2128450";
    src = pkgs.fetchFromGitHub {
      owner = "meuter";
      repo = "lualine-so-fancy.nvim";
      rev = "21284504fed2776668fdea8743a528774de5d2e1";
      hash = "sha256-JMz3Dv3poGoYQU+iq/jtgyHECZLx+6mLCvqUex/a0SY=";
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

    scrolloff = 12;

    termguicolors = true;

    hlsearch = false;
    incsearch = true;

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
      action = "<C-u>zz";
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
    {
      key = "<leader>n";
      mode = "n";
      options.silent = true;
      action = "vim.lsp.buf.hover";
      lua = true;
    }
    {
      key = "hh";
      mode = "n";
      action = '':Telescope harpoon marks<CR>'';
    }
    {
      key = "<leader>sa";
      mode = "n";
      options.silent = true;
      lua = true;
      action = "require('actions-preview').code_actions";
    }
    {
      key = "<leader>xx";
      mode = "n";
      lua = true;
      action = "require('trouble').toggle";
    }
    {
      key = "<leader>xw";
      mode = "n";
      lua = true;
      action = "function() require('trouble').toggle('workspace_diagnostics') end";
    }
    {
      key = "<leader>xd";
      mode = "n";
      lua = true;
      action = "function() require('trouble').toggle('document_diagnostics') end";
    }
    {
      key = "<leader>xq";
      mode = "n";
      lua = true;
      action = "function() require('trouble').toggle('quickfix') end";
    }
    {
      key = "<leader>xl";
      mode = "n";
      lua = true;
      action = "function() require('trouble').toggle('loclist') end";
    }
    {
      key = "gR";
      mode = "n";
      lua = true;
      action = "function() require('trouble').toggle('lsp_references') end";
    }
  ];

  globals = {
    minimap_width = 10;
    minimap_auto_start = 1;
    minimap_auto_start_win_enter = 1;
    minimap_close_buftypes = ["nofile"];
    minimap_block_filetypes = ["NvimTree"];

    mapleader = ";";

    mergetool_layout = "mr";
    mergetool_prefer_revision = "local";

    guifont = "JetBrains_Mono:h12";

    neovide_transparency = 0.8;
    neovide_padding_top = 10;
    neovide_padding_bottom = 10;
    neovide_padding_left = 10;
    neovide_padding_right = 10;
    neovide_floating_blur_amount_x = 10;
    neovide_floating_blur_amount_y = 10;
  };

  clipboard = {
    register = "unnamedplus";
    providers.wl-copy.enable = true;
  };

  extraConfigVim = ''
    if !exists("g:neovide")
      hi Normal guibg=NONE ctermbg=NONE
    endif
    set noshowmode
  '';

  extraConfigLua = ''
    require("darkman").setup()
    require("cmp-npm").setup({})
    require("rest-nvim").setup({})
    require("actions-preview").setup({})

    if vim.g.neovide then
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local flavour = require("catppuccin").options.background[vim.o.background]
          local palette = require("catppuccin.palettes").get_palette(flavour)
          vim.cmd("hi Normal guibg=" .. palette.base)
        end,
      })
    end

    local signs = {
      { name = "DiagnosticSignError", text = "" },
      { name = "DiagnosticSignWarn", text = "" },
      { name = "DiagnosticSignHint", text = "󰌵" },
      { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
      vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = true,
      severity_sort = false,
    })
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

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
    terminalColors = true;
    transparentBackground = true;
    background = {
      dark = "frappe";
      light = "latte";
    };
    integrations.native_lsp.underlines = {
      errors = ["undercurl"];
      warnings = ["undercurl"];
    };
    customHighlights =
      /*
      lua
      */
      ''
        function(colors)
          return {
            CmpItemKindCopilot = {fg = colors.teal},
            CmpItemKindNpm = {fg = colors.maroon},

            -- IntelliJ Theme
            Constant = {fg = colors.mauve},
            Character = {link = "Keyword"},
            Number = {fg = colors.sapphire},
            Boolean = {link = "Keyword"},
            Identifier = {fg = colors.text},
            Function = {fg = colors.blue},
            Statement = {fg = colors.text},
            Conditional = {link = "Keyword"},
            Repeat = {link = "Keyword"},
            Label = {link = "Keyword"},
            Operator = {fg = colors.text},
            Keyword = {fg = colors.peach},
            Exception = {link = "Keyword"},
            Include = {link = "Keyword"},
            Structure = {fg = colors.yellow},
            Type = {fg = colors.teal},

            SpellBad = {sp = colors.green, style = {"underdotted"}},
            SpellCap = {sp = colors.green, style = {"underdotted"}},
            SpellLocal = {sp = colors.green, style = {"underdotted"}},
            SpellRare = {sp = colors.green, style = {"underdotted"}},

            ["@constructor"] = {link = "Keyword"},
            ["@constructor.typescript"] = {link = "@constructor"},
            ["@parameter"] = {link = "Identifier"},

            ["@tag"] = {link = "Structure"},
            ["@tag.delimiter"] = {link = "Structure"},
            ["@tag.attribute"] = {fg = colors.mauve, style = {"italic"}}, -- Constant

            ["@keyword.function"] = {link = "Keyword"},
            ["@keyword.operator"] = {link = "Keyword"},
            ["@keyword.return"] = {link = "Keyword"},
            ["@keyword.export"] = {link = "Keyword"},

            ["@punctuation.special"] = {link = "Operator"},
            ["@conditional.ternary"] = {link = "Operator"},

            ["@type.builtin"] = {link = "Keyword"},
            ["@variable.builtin"] = {link = "Keyword"},
            ["@lsp.typemod.class.defaultLibrary"] = {fg = colors.yellow, style = {"bold"}}, -- Structure
            ["@lsp.typemod.variable.defaultLibrary"] = {fg = colors.mauve, style = {"bold"}}, -- Constant
            ["@lsp.typemod.function.defaultLibrary"] = {fg = colors.blue, style = {"bold"}}, -- Function

            ["@variable"] = {link = "Constant"},
            ["@field"] = {link = "Constant"},
            ["@label.json"] = {link = "Constant"},
            ["@label.jsonc"] = {link = "Constant"},
            ["@property"] = {link = "Constant"},
            ["@property.typescript"] = {link = "@property"},
            ["@lsp.type.property"] = {link = "Constant"},
            ["@lsp.type.interface"] = {link = "Structure"},
            ["@lsp.type.namespace"] = {link = "Structure"},
            ["@attribute.typescript"] = {link = "Structure"},

            ["@lsp.mod.local"] = {fg = colors.text},
            ["@lsp.mod.readonly"] = {style = {"italic"}},
          }
        end
      '';
  };

  plugins = {
    lualine = {
      enable = true;
      theme = "catppuccin";
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
        lualine_x = [
          {name = "fancy_lsp_servers";}
          {
            name = "filetype";
            extraConfig = {icon_only = true;};
            padding = {
              left = 1;
              right = 2;
            };
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
      scope.showStart = false;
    };
    illuminate.enable = true;
    nvim-autopairs.enable = true;
    nvim-colorizer.enable = true;
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
    notify = {
      enable = true;
      backgroundColour = "#000000";
    };
    toggleterm = {
      enable = true;
      openMapping = "<leader>t";
      direction = "vertical";
      size = 60;
    };
    luasnip.enable = true;
    ts-autotag.enable = true;
    leap.enable = true;
    harpoon = {
      enable = false;
      enableTelescope = true;
      keymaps = {
        addFile = "hm";
        navNext = "hn";
        navPrev = "hp";
      };
    };

    telescope = {
      enable = true;
      keymaps = {
        "<leader>ff" = "git_files";
        "<leader>fa" = "find_files";
        "<leader>fg" = "live_grep";
        "<leader>fb" = "buffers";

        "<leader>sr" = "lsp_references";
        "<leader>sd" = "lsp_definitions";
        "<leader>si" = "lsp_implementations";
        "<leader>ss" = "lsp_document_symbols";
        "<leader>sw" = "lsp_workspace_symbols";
        "<leader>st" = "lsp_type_definitions";
        "<leader>sh" = "diagnostics";
      };
    };

    trouble = {
      enable = true;
      useDiagnosticSigns = true;
    };

    treesitter = {
      enable = true;
      indent = true;
      grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      nixvimInjections = true;
    };

    none-ls = {
      enable = true;
      sources = {
        code_actions = {
          eslint_d.enable = true;
          shellcheck.enable = true;
        };
        diagnostics = {
          eslint_d = {
            enable = true;
            withArgs = ''
              {only_local = "node_modules/.bin"}
            '';
          };
          shellcheck.enable = true;
        };
        formatting = {
          alejandra.enable = true;
          prettier = {
            enable = true;
            withArgs = ''
              {extra_filetypes = {"svelte"}}
            '';
          };
          rustfmt.enable = true;
          shfmt.enable = true;
          stylua.enable = true;
        };
      };
      sourcesItems = [{__raw = "require('null-ls').builtins.diagnostics.stylelint";}];
      onAttach =
        /*
        lua
        */
        ''
          function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
              vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format({
                    filter = function(client)
                      return client.name == "null-ls"
                    end,
                    bufnr = bufnr,
                    async = false,
                  })
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

        rust-analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        pylsp.enable = true;

        nixd.enable = true;
        lua-ls.enable = true;
        bashls.enable = true;
      };
    };

    lspkind = {
      enable = true;
      mode = "symbol_text";
      cmp = {
        after =
          /*
          lua
          */
          ''
            function(entry, vim_item, kind)
              if entry.source.name == "npm" then
                kind.kind = ""
                kind.kind_hl_group = "CmpItemKindNpm"
              end
              kind.kind = kind.kind .. " "
              return kind
            end
          '';
      };
      symbolMap = {
        Copilot = "";
      };
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
        {name = "copilot";}
        {name = "path";}
        {name = "luasnip";}
        {
          name = "npm";
          keywordLength = 4;
          priority = 10;
        }
        {name = "nvim_lsp";}
        {name = "nvim_lsp_signature_help";}
        {name = "nvim_lsp_document_symbol";}
      ];
      formatting.fields = ["abbr" "kind"];
      snippet.expand = "luasnip";
      window = {
        completion.border = "rounded";
        documentation.border = "rounded";
      };
      experimental.ghost_text = true;
    };
    copilot-lua = {
      panel.enabled = false;
      suggestion.enabled = false;
    };

    nix.enable = true;
  };

  extraPackages = [angular-ls pkgs.nodePackages.typescript-language-server pkgs.nodePackages.stylelint pkgs.jq pkgs.html-tidy];
  extraPlugins = with pkgs.vimPlugins; [
    vim-startuptime
    vim-mergetool
    lualine-so-fancy
    darkman
    rest-nvim
    plenary-nvim
    actions-preview-nvim
  ];
}
