{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = ["nvidia"];

  boot.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  boot.extraModulePackages = [config.boot.kernelPackages.nvidia_x11];

  hardware.nvidia = {
    modesetting.enable = true;
    # seems to cause crashes on sleep
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = false;
    # no idea if this actually does anything...
    nvidiaPersistenced = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment = {
    variables = {
      VDPAU_DRIVER = "va_gl";
      LIBVA_DRIVER_NAME = "nvidia";
    };
    systemPackages = with pkgs; [
      nvtop-nvidia
      libva-utils
    ];
  };
}
