{ ... }:
{
  imports = [
    ./boot/quiet.nix

    ./desktops/hyprland.nix

    ./fonts/fira-code.nix
    ./fonts/noto-sans.nix
    ./fonts/nerd-fonts.nix

    ./hardware/hid-fanatecff.nix
    ./hardware/astro-a50.nix
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

    ./shell/dunst.nix
    ./shell/firefox-pip.nix
    ./shell/flameshot.nix
    ./shell/gnome-keyring.nix
    ./shell/grimblast.nix
    ./shell/hyprpicker.nix
    ./shell/kde-connect.nix
    ./shell/kitty.nix
    ./shell/swaync.nix
    ./shell/walker.nix
    ./shell/waybar.nix

    ./xdg/forced-compliance.nix
  ];
}
