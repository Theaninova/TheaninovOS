{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.services.nfsclient;
in
{
  options.services.nfsclient = {
    enable = mkEnableOption "Enable shared directory";
    ip = mkOption {
      type = types.str;
    };
    exportedDirs = mkOption {
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    boot.supportedFilesystems = [ "nfs" ];
    fileSystems = builtins.listToAttrs (
      lib.map (dir: {
        name = "/mnt/${dir}";
        value = {
          device = "${cfg.ip}:/shared";
          fsType = "nfs4";
          options = [
            "x-systemd.idle-timeout=600"
            "x-systemd.automount"
            "noauto"
          ];
        };
      }) cfg.exportedDirs
    );
  };
}
