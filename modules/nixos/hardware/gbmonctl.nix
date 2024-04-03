{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.hardware.gbmonctl;
in
{
  options.hardware.gbmonctl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mkDoc ''
        Enables a CLI tool to change monitor settings over USB to the Gigabyte M32U

        In theory any Gigabyte Monitor that uses a Realtek HID device (presumably the M28U also uses this) to control it over OSD sidekick should have the same protocol, but this is the only one I own.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gbmonctl ];
    services.udev.packages = [ pkgs.gbmonctl ];
  };
}
