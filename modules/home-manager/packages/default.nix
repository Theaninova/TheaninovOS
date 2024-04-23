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
    (import ./threema-desktop.nix { inherit pkgs; })
    (vesktop.override { withSystemVencord = false; })
    element-desktop

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
  ];
}
