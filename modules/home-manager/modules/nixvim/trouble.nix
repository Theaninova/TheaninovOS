{ lib, config, ... }:
let
  cfg = config.presets.trouble;
in
{
  options.presets.trouble = {
    enable = lib.mkEnableOption "trouble";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<leader>xx";
        mode = "n";
        action.__raw = # lua
          "function() require('trouble').toggle('diagnostics') end";
      }
      {
        key = "<leader>xw";
        mode = "n";
        action.__raw = # lua
          "function() require('trouble').toggle('workspace_diagnostics') end";
      }
      {
        key = "<leader>xd";
        mode = "n";
        action.__raw = # lua
          "function() require('trouble').toggle('document_diagnostics') end";
      }
      {
        key = "<leader>xq";
        mode = "n";
        action.__raw = # lua
          "function() require('trouble').toggle('quickfix') end";
      }
      {
        key = "<leader>xl";
        mode = "n";
        action.__raw = # lua
          "function() require('trouble').toggle('loclist') end";
      }
    ];
    plugins = {
      web-devicons.enable = true;
      trouble.enable = true;
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>x";
          group = "Trouble";
          icon = {
            icon = "";
            color = "red";
          };
        }
        {
          __unkeyed-1 = "<leader>xx";
          desc = "Toggle";
          icon = "󰺲";
        }
        {
          __unkeyed-1 = "<leader>xw";
          desc = "Workspace Diagnostics";
          icon = "󰙅";
        }
        {
          __unkeyed-1 = "<leader>xd";
          desc = "Document Diagnostics";
          icon = "󱪗";
        }
        {
          __unkeyed-1 = "<leader>xq";
          desc = "Quickfix";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>xl";
          desc = "Loclist";
          icon = "󰷐";
        }
      ];
    };
  };
}
