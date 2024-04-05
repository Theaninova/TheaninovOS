{ ... }:
{
  imports = [
    ./boot/quiet.nix

    ./desktops/hyprland.nix
    ./desktops/gamescope.nix

    ./fonts/fira-code.nix
    ./fonts/noto-sans.nix
    ./fonts/nerdfonts.nix

    ./hardware/audio.nix
    ./hardware/gbmonctl.nix
    ./hardware/nvidia-proprietary.nix
    ./hardware/nvidia-nouveau.nix
    ./hardware/amdgpu.nix
    ./hardware/cc1.nix
    ./hardware/fv43u.nix
    ./hardware/virtual-camera.nix

    ./locales/theaninova.nix

    ./services/airprint.nix
  ];
}
