{ pkgs, ... }:
{
  xdg.configFile."ranger/rc.conf".source = ./ranger.conf;
  home.packages = with pkgs; [
    # nix
    cachix
    lorri
    vulnix

    # browsers
    chromium
    brave

    # media
    jellyfin-media-player
    youtube-dl
    # tartube
    yt-dlp
    f3d
    mpv
    makemkv
    handbrake
    metadata-cleaner
    #bitwarden

    # chat apps
    threema-desktop
    vesktop
    discord
    element-desktop
    cinny-desktop

    # office
    libreoffice
    apostrophe # markdown editor

    # creative
    gimp
    inkscape-with-extensions
    scribus
    audacity
    pinta
    kdePackages.kdenlive
    losslesscut-bin
    shotcut
    blender-hip

    # development
    insomnia
    avalonia-ilspy
    ghidra
    ida-free

    # utils
    libqalculate
    ranger
    neofetch
    filezilla
    # rquickshare
  ];
}
