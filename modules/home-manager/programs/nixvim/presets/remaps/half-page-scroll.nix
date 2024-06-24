{ lib, config, ... }:
let
  cfg = config.presets.remaps.half-page-scroll;
in
{
  options.presets.remaps.half-page-scroll = {
    enable = lib.mkEnableOption "half page scroll";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        key = "<C-u>";
        action = "<C-u>zz";
      }
    ];
  };
}
