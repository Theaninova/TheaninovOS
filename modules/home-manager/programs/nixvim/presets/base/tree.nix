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
    ];
    plugins = {
      neo-tree = {
        enable = true;
        filesystem = {
          useLibuvFileWatcher = true;
          followCurrentFile.enabled = true;
          filteredItems.visible = true;
        };
        popupBorderStyle = "rounded";
        eventHandlers.file_opened = # lua
          ''
            function()
              require('neo-tree').close_all()
            end
          '';
      };
      which-key.registrations."<leader>f".t = "Tree";
    };
  };
}
