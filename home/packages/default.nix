{pkgs, ...}: {
  home.packages = with pkgs; [
    # nix
    cachix
    lorri

    # fix for proton games not launching without any error message
    libxcrypt

    # browsers
    firefox-wayland
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
    # BluRay support
    # Also downlaod the latest version of the decryption keys
    # http://fvonline-db.bplaced.net/
    # and put them into ~/.config/aacs/KEYDB.cfg
    (libbluray.override {
      withAACS = true;
      withJava = true;
      withBDplus = true;
    })

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
    # friture TODO: broken
    (blender.override {
      cudaSupport = true;
    })

    # development
    insomnia
    avalonia-ilspy
    ghidra

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
    lazydocker
    libqalculate
    ripgrep
    jq
    httpie
  ];
}
