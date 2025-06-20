{ pkgs, ... }:
{
  xdg.configFile."ranger/rc.conf".source = ./ranger.conf;
  services.flatpak.packages = [
    {
      flatpakref = "https://releases.threema.ch/flatpak/threema-desktop/ch.threema.threema-desktop.flatpakref";
      sha256 = "0lghiiiphbkqgiprqirxifldvix0j4k04jh1z9f911shrzjgqq4s";
    }
  ];
  home.packages = with pkgs; [
    # nix
    cachix
    # lorri
    vulnix
    gccdiag

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
    signal-desktop
    # cinny-desktop

    # office
    libreoffice
    apostrophe

    # creative
    gimp3
    inkscape-with-extensions
    scribus
    audacity
    pinta
    kdePackages.kdenlive
    losslesscut-bin
    shotcut
    blender-hip

    # development
    # TODO: .NET 6 avalonia-ilspy
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
