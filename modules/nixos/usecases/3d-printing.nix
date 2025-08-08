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
      openscad
      # orca-slicer
    ];
    home-manager.users.${username} = {
      services.flatpak.packages = [
        "com.bambulab.BambuStudio"
        "org.freecad.FreeCAD"
        "com.prusa3d.PrusaSlicer" # gcode viewer!
      ];
      programs = {
        lazygit.enable = true;
      };
    };
  };
}
