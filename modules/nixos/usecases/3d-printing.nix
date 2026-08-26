{
  config,
  lib,
  pkgs,
  username,
  ...
}:

with lib;

let
  cfg = config.usecases."3d-printing";
in
{
  options.usecases."3d-printing" = {
    enable = mkEnableOption "Enable 3d printing stuff";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lpc21isp
      dfu-util
    ];
    # Bambu Network Plugin
    networking.firewall = {
      allowedUDPPorts = [
        2021 # Discovery
      ];
      allowedTCPPorts = [
        8883 # MQTT
        6000 # MPEG over TLS
      ];
    };
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        freecad
        plasticity
        orca-slicer
      ];
      programs = {
        lazygit.enable = true;
      };
    };
  };
}
