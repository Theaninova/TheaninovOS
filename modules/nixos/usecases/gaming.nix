{
  config,
  lib,
  pkgs,
  username,
  ...
}:

with lib;

let
  cfg = config.usecases.gaming;
in
{
  options.usecases.gaming = {
    enable = mkEnableOption "Enable gaming things";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;

    services.udev.packages = with pkgs; [ oversteer ];
    users.users.${username}.extraGroups = [
      "wheel"
      "input"
      "games"
    ];

    environment.systemPackages = with pkgs; [
      steam
      cubyz-bin
      oversteer
      obs-studio
      /*
        (lutris.override {
          extraLibraries =
            pkgs: with pkgs; [
              libgudev
              libvdpau
            ];
        })
      */
      # rpcs3
      bottles
      wineWow64Packages.stagingFull
      winetricks
      protontricks
      mangohud
      gamescope
      gamemode
      # fix for some proton games not launching without any error message
      libxcrypt
    ];
  };
}
