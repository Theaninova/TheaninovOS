{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib;

let
  cfg = config.services.airprint;
in
{
  options.services.airprint = {
    enable = mkEnableOption "Enable printing over the air using sane and avahi";
  };

  config = mkIf cfg.enable {
    hardware.sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
    services.printing = {
      enable = true;
      stateless = true;
    };
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    users.users.${username}.extraGroups = [
      "lp"
      "scanner"
    ];
  };
}
