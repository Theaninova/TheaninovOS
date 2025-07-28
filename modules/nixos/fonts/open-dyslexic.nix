{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.fonts.open-dyslexic;
in
{
  options.fonts.open-dyslexic = {
    enable = mkEnableOption "Enable the OpenDyslexic font";
    default = mkOption {
      type = types.bool;
      description = "Make Noto Sans the default sans-serif font";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages =
        with pkgs;
        [
          open-dyslexic
        ]
        ++ (if (config.fonts.nerd-fonts.enable) then [ nerd-fonts.open-dyslexic ] else [ ]);
      fontconfig.defaultFonts = {
        sansSerif = mkIf cfg.default [
          (if (config.fonts.nerd-fonts.enable) then "OpenDyslexic Nerd Font" else "OpenDyslexic")
        ];
        monospace = mkIf cfg.default [
          (if (config.fonts.nerd-fonts.enable) then "OpenDyslexicM Nerd Font" else "OpenDyslexicM")
        ];
      };
    };
  };
}
