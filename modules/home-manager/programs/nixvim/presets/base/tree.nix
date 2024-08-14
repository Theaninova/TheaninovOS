{ lib, config, ... }:
let
  cfg = config.presets.base.tree;
in
{
  options.presets.base.tree = {
    enable = lib.mkEnableOption "file tree";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<leader>ft";
        action = "<cmd>:Neotree toggle<CR>";
      }
      {
        key = "<leader>ss";
        action = "<cmd>:Neotree document_symbols right toggle<CR>";
      }
    ];
    plugins = {
      neo-tree = {
        enable = true;
        filesystem = {
          useLibuvFileWatcher = true;
          followCurrentFile.enabled = true;
          filteredItems.visible = true;
        };
        extraSources = [ "document_symbols" ];
        popupBorderStyle = "rounded";
        eventHandlers.neo_tree_buffer_leave = # lua
          ''
            function()
              require('neo-tree').close_all()
            end
          '';
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>ft";
          desc = "Tree";
          icon = "󰙅";
        }
        {
          __unkeyed-1 = "<leader>ss";
          desc = "Document Symbols";
          icon = "󱏒";
        }
      ];
    };
  };
}
