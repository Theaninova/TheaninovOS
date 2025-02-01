{ lib, config, ... }:
let
  cfg = config.presets.remaps.wrapped-line-nav;
in
{
  options.presets.remaps.wrapped-line-nav = {
    enable = lib.mkEnableOption "Navigate wrapped lines up and down";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<up>";
        action = "g<up>";
      }
      {
        key = "<down>";
        action = "g<down>";
      }
    ];
  };
}
