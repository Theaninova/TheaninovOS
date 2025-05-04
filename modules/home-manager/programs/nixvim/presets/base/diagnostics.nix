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
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "solid" })
      '';
    diagnostics = {
      virtual_text.prefix = "●";
      signs = false;
      float = {
        focusable = false;
        header = "";
        border = "solid";
        scope = "cursor";
        prefix = "";
      };
      underline = true;
      update_in_insert = true;
      severity_sort = true;
    };
    keymaps = [
      {
        key = "<leader>sn";
        mode = "n";
        options.silent = true;
        action.__raw = # lua
          "function() vim.diagnostic.open_float(nil) end";
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
          "<leader>sa" = "quickfix";
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
          __unkeyed-1 = "<leader>sn";
          desc = "Diagnostics";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>sx";
          desc = "LSP Format";
          icon = "󰉢";
        }
      ];
    };
  };
}
