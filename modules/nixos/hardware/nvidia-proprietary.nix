{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib;

let
  cfg = config.hardware.nvidia.preset.proprietary;
in
{
  options.hardware.nvidia.preset.proprietary = {
    enable = mkEnableOption "Enable proprietary NVIDIA driver support with some sane defaults";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    boot = {
      kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    hardware.nvidia = {
      modesetting.enable = true;
      # seems to cause crashes on sleep
      powerManagement.enable = false;
      open = true;
      nvidiaSettings = false;
      # no idea if this actually does anything...
      nvidiaPersistenced = false;
    };

    home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
      cursor.no_hardware_cursors = true;
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
