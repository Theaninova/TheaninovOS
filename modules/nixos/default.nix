{ ... }: {
  imports = [
    ./boot/quiet.nix

    ./desktops/hyprland.nix

    ./fonts/fira-code.nix
    ./fonts/noto-sans.nix
    ./fonts/nerdfonts.nix

    ./hardware/audio.nix
    ./hardware/gbmonctl.nix
    ./hardware/nvidia.nix
    ./hardware/cc1.nix
    ./hardware/fv43u.nix
    ./hardware/virtual-camera.nix

    ./locales/theaninova.nix

    ./services/airprint.nix
  ];
}