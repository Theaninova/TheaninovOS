{ lib, config, ... }:
let
  cfg = config.presets.undotree;
in
{
  options.presets.undotree = {
    enable = lib.mkEnableOption "Undotree";
  };

  config = lib.mkIf cfg.enable {
    opts = {
      undodir.__raw = # lua
        "os.getenv('HOME') .. '/.config/nvim/undodir'";
      undofile = true;
    };
    keymaps = [
      {
        key = "<leader>u";
        mode = "n";
        action = "<cmd>:UndotreeToggle<CR>";
      }
    ];
    plugins = {
      undotree.enable = true;
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>u";
          desc = "Undotree";
          icon = "󰕌";
        }
      ];
    };
  };
}
