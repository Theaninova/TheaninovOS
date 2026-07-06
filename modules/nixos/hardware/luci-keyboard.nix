{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib;

let
  cfg = config.hardware.luci-keyboard;
in
{
  options.hardware.luci-keyboard = {
    enable = mkEnableOption "Enable Luci Keyboard Layout";
  };

  config = mkIf cfg.enable {
    home-manager.users."${username}".xdg.configFile."xkb/symbols/luci-keyboard".source =
      ./luci-keyboard;
    console.useXkbConfig = true;
    services.xserver.xkb = {
      layout = "luci-keyboard";
      extraLayouts.luci-keyboard = {
        description = "Luci's optimized layout";
        languages = [
          "ger"
        ];
        symbolsFile = ./luci-keyboard;
      };
    };
  };
}
