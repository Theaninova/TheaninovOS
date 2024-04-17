{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.shell.asztal;
in
{
  options.shell.asztal = {
    enable = mkEnableOption (mdDoc "Enable a shell based on AGS");
  };

  config = mkIf cfg.enable {
    systemd.user.services.asztal = {
      Unit = {
        Description = "asztal";
        PartOf = [
          "graphical-session.target"
          "tray.target"
        ];
      };
      Service = {
        ExecStart = "${pkgs.asztal}/bin/asztal";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "always";
        KillMode = "mixed";
        Environment = "PATH=/run/current-system/sw/bin/:${with pkgs; lib.makeBinPath [ ]}";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
