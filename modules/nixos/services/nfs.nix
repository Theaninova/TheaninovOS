{
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.services.nfshare;
  lockdPort = 4001;
  mountdPort = 4002;
  statdPort = 4000;
in
{
  options.services.nfshare = {
    enable = mkEnableOption "Enable shared directory";
    allowedIps = mkOption {
      type = types.listOf types.str;
    };
    baseDir = mkOption {
      type = types.str;
      default = "/export";
    };
    exportedDirs = mkOption {
      type = types.listOf types.str;
    };
  };

  config = mkIf cfg.enable {
    services.nfs.server = {
      inherit lockdPort mountdPort statdPort;
      enable = true;
      exports = (
        lib.concatStringsSep "\n" (
          lib.concatMap (
            ip:
            [ "${cfg.baseDir}         ${ip}(rw,fsid=0,no_subtree_check)" ]
            ++ (lib.map (
              dir: "${cfg.baseDir}/${dir}  ${ip}(rw,nohide,insecure,no_subtree_check)"
            ) cfg.exportedDirs)
          ) cfg.allowedIps
        )
      );
      extraNfsdConfig = "";
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        111
        2049
        lockdPort
        mountdPort
        statdPort
        20048
      ];
      allowedUDPPorts = [
        111
        2049
        lockdPort
        mountdPort
        statdPort
        20048
      ];
    };
  };
}
