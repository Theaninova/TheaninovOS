{
  config,
  lib,
  pkgs,
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

        #"fbcon=nodefer"
        #"fbcon=map:123"

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
    systemd.services = {
      plymouth-quit-wait = {
        after = lib.mkForce [ ];
        wantedBy = lib.mkForce [ ];
      };
      plymouth-quit = {
        after = lib.mkForce [
          "graphical.target"
          "greetd.service"
        ];
        wantedBy = lib.mkForce [ "graphical.target" ];
        serviceConfig = {
          ExecStart = [
            ""
            "-${pkgs.plymouth}/bin/plymouth quit --retain-splash"
            /*
              "-${
                (lib.getExe (
                  pkgs.writeShellApplication {
                    name = "plymouth-quit-delayed";
                    text = ''
                      ${pkgs.kbd}/bin/chvt 2; ${pkgs.coreutils}/bin/sleep 1; exec ${pkgs.plymouth}/bin/plymouth quit --retain-splash
                    '';
                  }
                ))
              }"
            */
          ];
          TTYVTDisallocate = true;
        };
        /*
          serviceConfig = {
            Type = "forking";
            ExecStart = [
              ""
              (lib.getExe (
                pkgs.writeShellApplication {
                  name = "plymouth-quit-delayed";
                  text = ''
                    ${pkgs.coreutils}/bin/sleep 5
                    ${pkgs.plymouth}/bin/plymouth quit --retain-splash
                  '';
                }
              ))
            ];
          };
          /*
            after = lib.mkForce [ ];
            wantedBy = lib.mkForce [ ];
            serviceConfig.ExecStart = [
              "-${pkgs.coreutils}/bin/sleep 5"
              "-${pkgs.plymouth}/bin/plymouth quit"
            ];
        */
      };
    };
  };
}
