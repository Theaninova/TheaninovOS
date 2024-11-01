{ config, lib, ... }:

with lib;

let
  cfg = config.usecases.development.angular;
in
{
  options.usecases.development.angular = {
    enable = mkEnableOption "Enable Angular develompent";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      3000
      8100
    ];
  };
}
