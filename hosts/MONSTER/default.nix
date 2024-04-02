# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, username, ... }: {
  imports = [ ./nvidia.nix ./hardware-configuration.nix ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--deleteOlderThan 10d";
    };
  };

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];

    # Silent Boot
    kernelParams = [
      # Redirect all kernel messages to a console off screen
      #"fbcon=vc:2-6"
      #"console=tty1"

      "video=3840x2160@144"
      # "splash"
      # "quiet"

      #"rd.udev.log_level=3"
      #"rd.systemd.show_status=false"
      #"udev.log_priority=3"
      #"boot.shell_on_fail"
      #"vt.global_cursor_default=0" # no cursor blinking
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    # Virtual Camera/Mic
    kernelModules = [ "v4l2loopback" "snd-aloop" "sg" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
  };

  # Audio
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # https://github.com/NixOS/nixpkgs/pull/300682
  # hardware.hid-fanatecff.enable = true;
  hardware.gbmonctl.enable = true;

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
  };
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-kde ];
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ anthy ];
    };
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  # Configure keymap in X11
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "cc1-thea";
    extraLayouts.cc1-thea = {
      description = "A CC1 optimized layout";
      languages = [ "eng" "ger" ];
      symbolsFile = ../../modules/cc1-thea;
    };
  };

  services.pcscd.enable = true;

  # nautilus on non-gnome
  services.gvfs.enable = true;
  # fix pinentry on non-gnome
  services.dbus.packages = with pkgs; [ gcr ];
  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.evolution-data-server.enable = true;

  services.udev.packages = with pkgs; [ oversteer android-udev-rules ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  services.getty.autologinUser = "${username}";
  services.getty.extraArgs = [ "--noclear" "--noissue" "--nonewline" ];
  services.getty.loginOptions = "-p -f -- \\u"; # preserve environment

  programs.hyprland.enable = true;
  programs.fish.enable = true;
  programs.kdeconnect.enable = true;
  security.sudo.configFile = ''
    Defaults env_reset,pwfeedback,passprompt="󰟵  "
  '';
  users.defaultUserShell = pkgs.fish;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "dialout"
      "plugdev"
      "scanner"
      "lp"
      "input"
      "adbusers"
      "cdrom"
    ];
  };

  # List packages installed in system profile. To search, run:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.systemPackages = with pkgs; [
    gamemode
    # Essential utils
    usbutils
    uhubctl
    pciutils
    htop
    unar
    gnupg
    libdrm
    alsa-utils
    graphicsmagick
    ffmpeg
    nfs-utils
    # Essential command line apps
    neovim
    mc
    git
    p7zip
    fzf
    eza
    # system-wide wine
    lutris
    wine-staging
    # docker
    docker-compose
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code
      (nerdfonts.override {
        fonts = [ "FiraCode" "JetBrainsMono" "Noto" "NerdFontsSymbolsOnly" ];
      })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "FiraCode Nerd Font" ];
        sansSerif = [ "Noto Sans Nerd Font" ];
      };
      localConf = builtins.readFile ./fontconfig.xml;
      subpixel.rgba = "bgr";
    };
  };

  networking = {
    firewall = {
      allowedTCPPorts = [ 8100 5037 5173 ];
      allowedUDPPorts = [ 50765 ];
    };

    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-openconnect ];
    };

    hosts = {
      "192.168.0.219" = [ "kookaborrow" ];
      "192.168.0.1" = [ "router" ];
    };
  };

  fileSystems."/mnt/media" = {
    device = "kookaborrow:/media";
    fsType = "nfs";
    options = [ "x-systemd-automount" "noauto" ];
  };

  fileSystems."/run/media/theaninova/heart-drive" = {
    device = "/dev/sdb2";
    fsType = "ntfs";
  };

  fileSystems."/run/media/theaninova/windows" = {
    device = "/dev/sda2";
    fsType = "ntfs";
  };
}
