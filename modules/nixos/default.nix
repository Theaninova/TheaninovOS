{ ... }:
{
  imports = [
    ./boot/quiet.nix

    ./desktops/hyprland.nix
    ./desktops/gamescope.nix

    ./fonts/fira-code.nix
    ./fonts/noto-sans.nix
    ./fonts/nerdfonts.nix

    ./hardware/hid-fanatecff.nix
    ./hardware/audio.nix
    ./hardware/gbmonctl.nix
    ./hardware/nvidia-proprietary.nix
    ./hardware/nvidia-nouveau.nix
    ./hardware/amdgpu.nix
    ./hardware/cc1.nix
    ./hardware/fv43u.nix
    ./hardware/q3279vwf.nix
    ./hardware/virtual-camera.nix

    ./locales/theaninova.nix

    ./usecases/gaming.nix
    ./usecases/3d-printing.nix
    ./usecases/development.nix
    ./usecases/windows-vm.nix

    ./services/airprint.nix

    ./shell/waybar.nix
    ./shell/dunst.nix

    ./xdg/forced-compliance.nix
  ];
}
