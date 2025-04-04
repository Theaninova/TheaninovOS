{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.fonts.noto-sans;
in
{
  options.fonts.noto-sans = {
    enable = mkEnableOption "Enable the Noto Sans font";
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
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-emoji
        ]
        ++ (if (config.fonts.nerd-fonts.enable) then [ nerd-fonts.noto ] else [ ]);
      fontconfig = {
        defaultFonts.sansSerif = mkIf cfg.default [
          (if (config.fonts.nerd-fonts.enable) then "Noto Sans Nerd Font" else "Noto Sans")
        ];
      };
    };
  };
}
