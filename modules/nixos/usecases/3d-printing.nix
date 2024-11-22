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
      cura
      openscad
      (orca-slicer.overrideAttrs (
        final: prev: {
          version = "2.2.0";
          src = fetchFromGitHub {
            owner = "SoftFever";
            repo = "OrcaSlicer";
            rev = "v${final.version}";
            hash = "sha256-h+cHWhrp894KEbb3ic2N4fNTn13WlOSYoMsaof0RvRI=";
          };
          patches = builtins.filter (
            p:
            (builtins.baseNameOf p) != "0002-fix-build-for-gcc-13.diff"
            && (builtins.baseNameOf p) != "meshboolean-const.patch"
          ) prev.patches;
        }
      ))
      freecad
    ];
  };
}
