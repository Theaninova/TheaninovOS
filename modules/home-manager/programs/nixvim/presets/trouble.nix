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
    ];
    plugins = {
      trouble = {
        enable = true;
        settings.use_diagnostic_signs = true;
      };
      which-key.registrations."<leader>x" = {
        name = "Trouble";
        x = "Toggle";
        w = "Workspace Diagnostics";
        d = "Document Diagnostics";
        q = "Quickfix";
        l = "Loclist";
      };
    };
  };
}
