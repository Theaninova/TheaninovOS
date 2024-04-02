{ config, lib, ... }:

with lib;

let cfg = config.boot.quiet;

in {
  options.boot.quiet = { enable = mkEnableOption (mdDoc "Clean, quiet boot"); };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        timeout = 0;
        systemd-boot.consoleMode = "max";
      };

      plymouth.enable = true;

      kernelParams = [
        # Redirect all kernel messages to a console off screen
        #"fbcon=vc:2-6"
        #"console=tty1"

        "splash"
        "quiet"

        #"rd.udev.log_level=3"
        #"rd.systemd.show_status=false"
        #"udev.log_priority=3"
        #"boot.shell_on_fail"
        #"vt.global_cursor_default=0" # no cursor blinking
      ];
      consoleLogLevel = 0;
      initrd.verbose = false;
    };
  };
}
