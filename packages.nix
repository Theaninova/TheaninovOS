{pkgs}:
with pkgs; [
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
  # youtube-music.override {electron = pkgs.electron_28;})
  vlc
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
  (import ./packages/threema-desktop.nix {inherit pkgs;})
  (discord.override {
    withOpenASAR = true;
    withVencord = false;
  })
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
  # friture TODO: broken
  blender

  # development
  (import ./packages/intellij.nix {inherit pkgs;})
  jetbrains.rust-rover
  insomnia
  avalonia-ilspy

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
]
