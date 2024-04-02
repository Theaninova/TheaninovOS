{ pkgs, lib, config, ... }:
with lib;

let cfg = config.fonts.nerdfonts;

in {
  options.fonts.nerdfonts = {
    enable = mkEnableOption "Enable nerdfonts";
    additionalFonts = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional fonts to include in the nerdfonts package";
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs;
        [
          (nerdfonts.override {
            fonts = [ "NerdFontsSymbolsOnly" ] ++ cfg.additionalFonts;
          })
        ];
    };
  };
}
