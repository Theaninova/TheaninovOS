{ ... }:
{
  imports = [
    ./boot/quiet.nix

    ./desktops/hyprland.nix
    ./desktops/niri.nix

    ./fonts/fira-code.nix
    ./fonts/noto-sans.nix
    ./fonts/nerd-fonts.nix
    ./fonts/open-dyslexic.nix

    ./hardware/audio-share.nix
    ./hardware/astro-a50.nix
    ./hardware/audio.nix
    ./hardware/gbmonctl.nix
    ./hardware/luci-keyboard.nix
    ./hardware/nvidia-proprietary.nix
    ./hardware/nvidia-nouveau.nix
    ./hardware/amdgpu.nix
    ./hardware/cc1.nix
    ./hardware/fv43u.nix
    ./hardware/pimax.nix
    ./hardware/q3279vwf.nix
    ./hardware/virtual-camera.nix

    ./locales/theaninova.nix

    ./usecases/3d-printing.nix
    ./usecases/development.nix
    ./usecases/flatpak.nix
    ./usecases/gaming.nix
    ./usecases/localai.nix
    ./usecases/nix-ld.nix
    ./usecases/windows-vm.nix

    ./services/airprint.nix
    ./services/nfs.nix
    ./services/nfsclient.nix

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
