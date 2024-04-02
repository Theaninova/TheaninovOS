{ pkgs, lib, config, username, ... }:
with lib;

let cfg = config.hardware.cc1;

in {
  options.hardware.cc1 = {
    enable = mkEnableOption "Enable CC1 optimizations";
    layout = mkOption {
      type = with lib.types; enum [ "cc1-thea" ];
      default = "cc1-thea";
    };
  };

  config = mkIf cfg.enable {
    # TODO: per-device layout?
    console.useXkbConfig = true;
    services.xserver.xkb = {
      layout = cfg.layout;
      extraLayouts.cc1-thea = {
        description = "A CC1 optimized layout";
        languages = [ "eng" "ger" ];
        symbolsFile = ./${cfg.layout};
      };
    };

    users.users.${username}.extraGroups = [ "dialout" ];
  };
}
