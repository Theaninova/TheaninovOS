{ lib, config, ... }:
let
  cfg = config.presets.remaps.no-accidental-macro;
in
{
  options.presets.remaps.no-accidental-macro = {
    enable = lib.mkEnableOption "no accidental macro";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "Q";
        mode = "n";
        action = "<nop>";
      }
    ];
  };
}
