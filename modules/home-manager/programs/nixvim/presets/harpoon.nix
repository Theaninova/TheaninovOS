{ lib, config, ... }:
let
  cfg = config.presets.harpoon;
in
{
  options.presets.harpoon = {
    enable = lib.mkEnableOption "Harpoon";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "hh";
        mode = "n";
        action = ":Telescope harpoon marks<CR>";
      }
    ];
    plugins = {
      telescope.enable = true;
      harpoon = {
        enable = true;
        enableTelescope = true;
        keymaps = {
          addFile = "hm";
          navNext = "hn";
          navPrev = "hp";
        };
      };
      which-key.registrations.h = {
        name = "Harpoon";
        h = "Marks";
        m = "Mark";
        n = "Next";
        p = "Prev";
      };
    };
  };
}
