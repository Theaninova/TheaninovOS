{ pkgs, lib, config, ... }:
let cfg = config.hardware.gbmonctl;
in with lib; {
  options.hardware.gbmonctl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mkDoc ''
        Enables a CLI tool to change monitor settings over USB to the Gigabyte M32U

        In theory any Gigabyte Monitor that uses a Realtek HID device (presumably the M28U also uses this) to control it over OSD sidekick should have the same protocol, but this is the only one I own.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gbmonctl ];
    services.udev.packages = [ pkgs.gbmonctl ];
  };
}
