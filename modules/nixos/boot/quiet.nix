{ config, lib, ... }:

with lib;

let
  cfg = config.boot.quiet;
in
{
  options.boot.quiet = {
    enable = mkEnableOption (mdDoc "Clean, quiet boot");
  };

  config = mkIf cfg.enable {
    boot = {
      loader.timeout = 0;

      # plymouth.enable = true;

      kernelParams = [
        "quiet"

        "rd.udev.log_level=3"
        "rd.systemd.show_status=false"
        "udev.log_priority=3"
        "vt.global_cursor_default=0" # no cursor blinking
      ];
      consoleLogLevel = 0;
      initrd.verbose = false;
    };
  };
}
