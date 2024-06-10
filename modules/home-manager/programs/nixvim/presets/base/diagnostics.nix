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
    extraConfigLua = ''
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

      vim.diagnostic.config({
      	virtual_text = true,
      	signs = true,
      	underline = true,
      	update_in_insert = true,
      	severity_sort = false,
      })
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    '';
    keymaps = [
      {
        key = "<leader>sa";
        mode = "n";
        options.silent = true;
        lua = true;
        action = "require('actions-preview').code_actions";
      }
      {
        key = "<leader>sx";
        mode = "n";
        options.silent = true;
        lua = true;
        action = "vim.lsp.buf.format";
      }
      {
        key = "<leader>sR";
        mode = "n";
        options.silent = true;
        action = "<cmd>:LspRestart<CR>";
      }
      {
        key = "<leader>sn";
        mode = "n";
        options.silent = true;
        action = "vim.lsp.buf.hover";
        lua = true;
      }
    ];
    plugins = {
      lsp.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>sr" = "lsp_references";
          "<leader>sd" = "lsp_definitions";
          "<leader>si" = "lsp_implementations";
          "<leader>ss" = "lsp_document_symbols";
          "<leader>sw" = "lsp_workspace_symbols";
          "<leader>st" = "lsp_type_definitions";
          "<leader>sh" = "diagnostics";
        };
      };
      which-key.registrations."<leader>s" = {
        name = "LSP";
        n = "Hover";
        r = "References";
        R = "Restart LSP";
        d = "Definitions";
        i = "Implementations";
        s = "Document Symbols";
        w = "Workspace Symbols";
        t = "Type Definitions";
        h = "Diagnostics";
        a = "Code Actions";
        x = "LSP Format";
      };
    };
    extraPlugins = [ pkgs.vimPlugins.actions-preview-nvim ];
  };
}
