{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.usecases.development.docker;
in
{
  options.usecases.development.docker = {
    enable = mkEnableOption "Enable Docker stuff";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lazydocker
      docker-compose
    ];

    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
