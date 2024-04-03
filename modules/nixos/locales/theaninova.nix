{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.locale.preset.theaninova;
in
{
  options.locale.preset.theaninova = {
    enable = mkEnableOption "Enable the locale preset for Theaninova";
  };

  config = mkIf cfg.enable {
    time.timeZone = "Europe/Berlin";
    i18n = {
      inputMethod = {
        enabled = "ibus";
        ibus.engines = [ pkgs.ibus-engines.anthy ];
      };
      defaultLocale = "en_GB.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };
  };
}
