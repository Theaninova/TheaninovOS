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
          window.position = "float";
          filesystem = {
            use_libuv_file_watcher = true;
            follow_current_file.enabled = true;
            filtered_items.visible = true;
          };
          popup_border_style = "";
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
