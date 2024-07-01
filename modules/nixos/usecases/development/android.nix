{
  config,
  username,
  lib,
  ...
}:

with lib;

let
  cfg = config.usecases.development.android;
in
{
  options.usecases.development.android = {
    enable = mkEnableOption "Android develompent";
  };

  config = mkIf cfg.enable {
    users.users.${username}.extraGroups = [ "adbusers" ];
    networking.firewall.allowedTCPPorts = [ 5037 ];
  };
}
