{ pkgs }: with pkgs; [
  # nix
  cachix
  lorri
  
  # browsers
  firefox-wayland
  chromium
  brave
  
  # media
  jellyfin-media-player
  youtube-music
  vlc
  makemkv
  handbrake
  metadata-cleaner

  # chat apps
  (import ./packages/threema-desktop.nix { inherit pkgs; })
  (discord.override {
    withOpenASAR = true;
    withVencord = true;
  })
  slack
  
  # office
  libreoffice
  apostrophe # markdown editor
  
  # creative
  gimp-with-plugins
  inkscape-with-extensions
  audacity
  friture
  blender
   
  # development
  (import ./packages/intellij.nix { inherit pkgs; })
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
]
