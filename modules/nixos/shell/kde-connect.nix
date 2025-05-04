{
  config,
  lib,
  username,
  ...
}:

let
  cfg = config.shell.components.kde-connect;
in
{
  options.shell.components.kde-connect = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable a pre-configured kde connect setup");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.services.kdeconnect.enable = true;
    networking.firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };
}
