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
        key = "ft";
        mode = "n";
        action = # vim
          "<cmd>:Neotree toggle<CR>";
      }
    ];
    plugins = {
      web-devicons.enable = true;
      neo-tree = {
        enable = true;
        filesystem = {
          useLibuvFileWatcher = true;
          followCurrentFile.enabled = true;
          filteredItems.visible = true;
        };
        popupBorderStyle = "rounded";
        filesystem.window.mappings.f = "noop";
        window.mappings.f = "noop";
        eventHandlers.neo_tree_buffer_leave = # lua
          ''
            function()
              require('neo-tree').close_all()
            end
          '';
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "ft";
          desc = "Tree";
          icon = "󰙅";
        }
      ];
    };
  };
}
