{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.presets.base.diagnostics;
in
{
  options.presets.base.diagnostics = {
    enable = lib.mkEnableOption "diagnostics";
  };

  config = lib.mkIf cfg.enable {
    extraConfigLuaPre = # lua
      ''
        vim.lsp.set_log_level("off")
        require("actions-preview").setup({})

        local signs = {
        	{ name = "DiagnosticSignError", text = "" },
        	{ name = "DiagnosticSignWarn", text = "" },
        	{ name = "DiagnosticSignHint", text = "󰌵" },
        	{ name = "DiagnosticSignInfo", text = "" },
        }

        for _, sign in ipairs(signs) do
        	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "solid" })
      '';
    diagnostics = {
      signs.text = {
        "__rawKey__vim.diagnostic.severity.ERROR" = "";
        "__rawKey__vim.diagnostic.severity.WARN" = "";
        "__rawKey__vim.diagnostic.severity.INFO" = "";
        "__rawKey__vim.diagnostic.severity.HINT" = "󰌵";
      };
      underline = true;
      update_in_insert = true;
      severity_sort = true;
    };
    keymaps = [
      {
        key = "<leader>sa";
        mode = "n";
        options.silent = true;
        action.__raw = # lua
          "require('actions-preview').code_actions";
      }
      {
        key = "<leader>sx";
        mode = "n";
        options.silent = true;
        action.__raw = # lua
          "vim.lsp.buf.format";
      }
      {
        key = "<leader>sR";
        mode = "n";
        options.silent = true;
        action = "<cmd>:LspRestart<CR>";
      }
      {
        key = "<leader>sc";
        mode = "n";
        action = ":IncRename ";
      }
      {
        key = "<leader>sn";
        mode = "n";
        options.silent = true;
        action.__raw = # lua
          "vim.lsp.buf.hover";
      }
      {
        key = "<leader>sh";
        mode = "n";
        options.silent = true;
        action.__raw = # lua
          "function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}), {0}) end";
      }
    ];
    plugins = {
      lsp = {
        enable = true;
        inlayHints = false;
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>sr" = "lsp_references";
          "<leader>sd" = "lsp_definitions";
          "<leader>si" = "lsp_implementations";
          "<leader>sw" = "lsp_workspace_symbols";
          "<leader>st" = "lsp_type_definitions";
        };
      };
      inc-rename.enable = true;
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>s";
          group = "LSP";
          icon = "󱐋";
        }
        {
          __unkeyed-1 = "<leader>sn";
          desc = "Hover";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>sr";
          desc = "References";
          icon = "󱁉";
        }
        {
          __unkeyed-1 = "<leader>sc";
          desc = "Incremental Rename";
          icon = "󰑕";
        }
        {
          __unkeyed-1 = "<leader>sR";
          desc = "Restart LSP";
          icon = "󰜉";
        }
        {
          __unkeyed-1 = "<leader>sd";
          desc = "Definitions";
          icon = "󰜬";
        }
        {
          __unkeyed-1 = "<leader>si";
          desc = "Implementations";
          icon = "󰴽";
        }
        {
          __unkeyed-1 = "<leader>sw";
          desc = "Workspace Symbols";
          icon = "󰷐";
        }
        {
          __unkeyed-1 = "<leader>st";
          desc = "Type Definitions";
          icon = "󱍕";
        }
        {
          __unkeyed-1 = "<leader>sh";
          icon = "󰞂";
          desc = "Inlay Hints";
        }
        {
          __unkeyed-1 = "<leader>sa";
          desc = "Code Actions";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>sx";
          desc = "LSP Format";
          icon = "󰉢";
        }
      ];
    };
    extraPlugins = [ pkgs.vimPlugins.actions-preview-nvim ];
  };
}
