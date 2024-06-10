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
      undodir = {
        __raw = "os.getenv('HOME') .. '/.config/nvim/undodir'";
      };
      undofile = true;
    };
    plugins = {
      undotree.enable = true;
      which-key.registrations."<leader>u" = "Undotree";
    };
  };
}
