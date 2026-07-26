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
    networking.firewall.allowedUDPPorts = [ 2021 ];
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        orca-slicer
      ];
      programs = {
        lazygit.enable = true;
      };
    };
  };
}
