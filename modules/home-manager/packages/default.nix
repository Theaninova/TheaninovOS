{ pkgs, ... }:
{
  xdg.configFile."ranger/rc.conf".source = ./ranger.conf;
  home.packages = with pkgs; [
    # nix
    cachix
    lorri

    # fix for proton games not launching without any error message
    libxcrypt

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
    bitwarden

    # chat apps
    (import ./threema-desktop.nix { inherit pkgs; })
    (vesktop.override { electron = pkgs.electron_29; })
    (element-desktop.override { electron = pkgs.electron_29; })
    slack

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
    openscad-unstable

    # development
    insomnia
    avalonia-ilspy
    ghidra

    # 3d printing
    lpc21isp
    dfu-util
    cura

    # gaming
    steam
    oversteer
    obs-studio
    cartridges
    bottles
    protontricks
    mangohud

    # utils
    gh
    git-filter-repo
    neofetch
    ranger
    filezilla
    lazydocker
    libqalculate
    ripgrep
    jq
    httpie
  ];
}
