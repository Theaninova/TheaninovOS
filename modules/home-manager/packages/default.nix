{ pkgs, ... }:
{
  xdg.configFile."ranger/rc.conf".source = ./ranger.conf;
  home.packages = with pkgs; [
    # nix
    cachix
    # lorri
    vulnix

    # browsers
    chromium
    brave

    # media
    jellyfin-media-player
    yt-dlp
    f3d
    mpv
    makemkv
    handbrake
    metadata-cleaner

    # chat apps
    vesktop
    discord
    element-desktop
    thunderbird
    # cinny-desktop

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
    # ghidra
    # ida-free

    # utils
    libqalculate
    ranger
    neofetch
    filezilla
    # rquickshare
  ];
}
