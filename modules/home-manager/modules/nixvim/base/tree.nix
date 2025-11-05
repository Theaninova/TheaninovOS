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
        key = "<leader>t";
        mode = "n";
        action = # vim
          "<cmd>:Neotree toggle<CR>";
      }
    ];
    plugins = {
      web-devicons.enable = true;
      neo-tree = {
        enable = true;
        settings = {
          event_handlers = [
            {
              event = "neo_tree_buffer_leave";
              handler.__raw = ''
                function()
                  require('neo-tree').close_all()
                end
              '';
            }
          ];
          filesystem = {
            use_libuv_file_watcher = true;
            follow_current_file.enabled = true;
            filtered_items.visible = true;
          };
          popupBorderStyle = "rounded";
        };
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>t";
          desc = "Tree";
          icon = "󰙅";
        }
      ];
    };
  };
}
