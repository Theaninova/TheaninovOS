{
  config,
  lib,
  pkgs,
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
      bambu-studio
      prusa-slicer # gcode viewer!
      orca-slicer
      freecad
    ];
  };
}
