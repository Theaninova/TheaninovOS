{ pkgs, ... }:
{
  xdg.configFile."ranger/rc.conf".source = ./ranger.conf;
  home.packages = with pkgs; [
    # nix
    cachix
    # lorri
    vulnix

    # browsers
    firefox
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
    apostrophe

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
    # TODO: .NET 6 avalonia-ilspy
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
