{
  config,
  lib,
  username,
  ...
}:

with lib;

let
  cfg = config.boot.quiet;
in
{
  options.boot.quiet = {
    enable = mkEnableOption (mdDoc "Clean, quiet boot");
  };

  config = mkIf cfg.enable {
    users.users.${username}.linger = true;
    boot = {
      loader.timeout = 0;

      plymouth.enable = true;

      kernelParams = [
        "quiet"

        "rd.udev.log_level=3"
        "rd.systemd.show_status=false"
        "udev.log_priority=3"
        "vt.global_cursor_default=0" # no cursor blinking
      ];
      consoleLogLevel = 0;
      initrd = {
        verbose = false;
        systemd = {
          enable = true;
          services = {
            #plymouth-quit.wantedBy = lib.mkForce [ ];
            # plymouth-quit-wait.wantedBy = lib.mkForce [ ];
          };
        };
      };
    };
    services.greetd.greeterManagesPlymouth = true;
    /*
      systemd.services = {
        plymouth-quit-wait = {
          overrideStrategy = "asDropin";
          after = [ "graphical-session.target" ];
          wantedBy = lib.mkForce [ "graphical-session.target" ];
        };
        plymouth-quit = {
          overrideStrategy = "asDropin";
          after = [ "graphical-session.target" ];
          wantedBy = lib.mkForce [ "graphical-session.target" ];
        };
      };
    */
  };
}
