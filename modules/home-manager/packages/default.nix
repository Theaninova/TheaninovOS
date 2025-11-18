{ pkgs, ... }:
{
  xdg.configFile."ranger/rc.conf".source = ./ranger.conf;
  services.flatpak.packages = [
    {
      flatpakref = "https://releases.threema.ch/flatpak/threema-desktop/ch.threema.threema-desktop.flatpakref";
      sha256 = "0lghiiiphbkqgiprqirxifldvix0j4k04jh1z9f911shrzjgqq4s";
    }
  ];
  programs.mpv.enable = true;
  home.packages = with pkgs; [
    # nix
    cachix
    # lorri
    vulnix
    gccdiag

    # browsers
    firefox
    chromium

    # media
    yt-dlp
    f3d
    jellyfin-mpv-shim
    makemkv
    libfaketime
    handbrake
    metadata-cleaner
    mediainfo
    mediainfo-gui

    prismlauncher

    # chat apps
    vesktop
    discord
    element-desktop
    thunderbird
    signal-desktop
    # cinny-desktop

    # office
    libreoffice
    apostrophe

    # creative
    gimp3
    inkscape-with-extensions
    scribus
    # audacity
    pinta
    losslesscut-bin
    shotcut
    blender-hip

    # development
    ghidra

    # utils
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
