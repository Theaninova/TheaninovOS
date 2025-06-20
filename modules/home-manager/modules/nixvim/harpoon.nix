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
      which-key.settings.spec = [
        {
          __unkeyed-1 = "h";
          group = "Harpoon";
          icon = "󱀺";
        }
        {
          __unkeyed-1 = "hh";
          desc = "Marks";
          icon = "󰈢";
        }
        {
          __unkeyed-1 = "hm";
          desc = "Add File";
          icon = "󱪝";
        }
        {
          __unkeyed-1 = "hn";
          desc = "Next";
          icon = "";
        }
        {
          __unkeyed-1 = "hp";
          desc = "Prev";
          icon = "";
        }
      ];
    };
  };
}
