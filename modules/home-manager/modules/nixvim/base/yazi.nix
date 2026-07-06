{ lib, config, ... }:
let
  cfg = config.presets.base.yazi;
in
{
  options.presets.base.yazi = {
    enable = lib.mkEnableOption "yazi";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<leader>y";
        mode = [
          "n"
          "v"
        ];
        action = # vim
          "<cmd>Yazi<CR>";
      }
    ];
    globals.loaded_netrwPlugin = 1;
    plugins = {
      web-devicons.enable = true;
      yazi = {
        enable = true;
        settings = {
          enable_mouse_support = true;
          open_for_directories = true;
          yazi_floating_window_border = "none";
          keymaps.show_help = "<?>";
        };
        lazyLoad = {
          enable = true;
          settings.cmd = "Yazi";
        };
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>y";
          desc = "Yazi";
          icon = "󰙅";
        }
      ];
    };
  };
}
