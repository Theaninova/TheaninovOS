{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.fonts.nerd-fonts;
in
{
  options.fonts.nerd-fonts = {
    enable = mkEnableOption "Enable nerdfonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        nerd-fonts.symbols-only
      ];
    };
  };
}
