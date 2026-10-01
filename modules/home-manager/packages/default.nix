{ pkgs, ... }:
{
  xdg.configFile."ranger/rc.conf".source = ./ranger.conf;
  services.flatpak.packages = [
    {
      flatpakref = "https://releases.threema.ch/flatpak/threema-desktop/ch.threema.threema-desktop.flatpakref";
      sha256 = "0lghiiiphbkqgiprqirxifldvix0j4k04jh1z9f911shrzjgqq4s";
    }
  ];
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    config = {
      tone-mapping = "mobius";
    };
  };
  home.packages = with pkgs; [
    cachix
    vulnix

    # browsers
    firefox
    chromium
    bitwarden-desktop

    # media
    f3d
    makemkv
    libfaketime
    handbrake
    metadata-cleaner
    mediainfo
    mediainfo-gui

    prismlauncher

    # chat apps
    vesktop
    thunderbird
    signal-desktop

    # office
    apostrophe

    # creative
    gimp3
    inkscape-with-extensions
    # scribus
    audacity
    pinta
    losslesscut-bin
    pkgsRocm.blender

    # development
    ghidra
    kdePackages.kate
    tinymist
    typewriter

    # utils
    kdePackages.ark
    bazaar
    libqalculate
    ranger
    filezilla
    yubikey-manager
    (pkgs.writeShellApplication {
      name = "fix-yubikey";
      text = ''
        gpg-connect-agent --hex "scd apdu 00 f1 00 00" /bye
      '';
    })
  ];
}
