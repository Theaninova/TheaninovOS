{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.fonts.fira-code;
in
{
  options.fonts.fira-code = {
    enable = mkEnableOption "Enable the preset for Fira Code";
    stylisticSets = mkOption {
      type = types.listOf types.str;
      description = mdDoc "[Stylistic sets](https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets) for Fira Code";
      default = [
        "zero"
        "onum"
        "ss04"
        "cv19"
        "cv23"
        "ss09"
        "cv26"
        "ss06"
        "ss10"
      ];
    };
    default = mkOption {
      type = types.bool;
      description = "Make Fira Code the default monospace font";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      packages =
        with pkgs;
        [
          fira-code
        ]
        ++ (if (config.fonts.nerd-fonts.enable) then [ nerd-fonts.fira-code ] else [ ]);
      fontconfig = {
        defaultFonts.monospace = mkIf cfg.default [
          (if (config.fonts.nerd-fonts.enable) then "Fira Code Nerd Font" else "FiraCode")
        ];
        localConf = ''
          <match target="font">
            <test name="family" compare="contains">
              <string>Fira</string>
            </test>
            <edit name="fontfeatures" mode="append">
              ${lib.concatStringsSep " " (map (set: "<string>${set}</string>") cfg.stylisticSets)}
            </edit>
          </match>
        '';
      };
    };
  };
}
