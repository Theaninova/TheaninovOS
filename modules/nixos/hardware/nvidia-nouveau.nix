{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.hardware.nvidia.preset.nouveau;
in
{
  options.hardware.nvidia.preset.nouveau = {
    enable = mkEnableOption "Enable the free Nouveau NVIDIA driver with some sane defaults";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    boot = {
      kernelParams = [ "nouveau.modeset=1" ];
      kernelModules = [ "nouveau" ];
      initrd.kernelModules = [ "nouveau" ];
    };

    environment.systemPackages = with pkgs; [
      glxinfo
      libva-utils
      vulkan-tools
    ];
  };
}
