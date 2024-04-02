{ pkgs, lib, config, ... }:
with lib;

let cfg = config.hardware.nvidia.preset.proprietary;

in {
  options.hardware.nvidia.preset.proprietary = {
    enable = mkEnableOption
      "Enable proprietary NVIDIA driver support with some sane defaults";
  };

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ libvdpau-va-gl nvidia-vaapi-driver ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    boot.kernelParams = [ "fbdev=1" "nvidia_drm.fbdev=1" ];
    boot.kernelModules =
      [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    boot.initrd.kernelModules =
      [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    hardware.nvidia = {
      modesetting.enable = true;
      # seems to cause crashes on sleep
      powerManagement.enable = false;
      open = true;
      nvidiaSettings = false;
      # no idea if this actually does anything...
      nvidiaPersistenced = false;
    };

    environment = {
      variables = {
        VDPAU_DRIVER = "va_gl";
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
      systemPackages = with pkgs; [
        glxinfo
        nvtopPackages.nvidia
        libva-utils
        vulkan-tools
      ];
    };
  };
}
