{pkgs, ...}: {
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
    tartube
    yt-dlp
    # youtube-music.override {electron = pkgs.electron_28;})
    mpv
    makemkv
    handbrake
    metadata-cleaner
    bitwarden

    # chat apps
    (import ./threema-desktop.nix {inherit pkgs;})
    (vesktop.override {electron = pkgs.electron_28;})
    (element-desktop.override {electron = pkgs.electron_28;})
    slack

    # office
    libreoffice
    apostrophe # markdown editor

    # creative
    gimp-with-plugins
    inkscape-with-extensions
    scribus
    audacity
    pinta
    kdePackages.kdenlive
    # friture TODO: broken
    (blender.override {
      cudaSupport = true;
    })
    openscad-unstable

    # development
    insomnia
    avalonia-ilspy
    ghidra

    # 3d printing
    lpc21isp
    dfu-util
    cura
    orca-slicer

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
    pinentry-gnome
    ranger
    filezilla
    lazydocker
    libqalculate
    ripgrep
    jq
    httpie
  ];
}
