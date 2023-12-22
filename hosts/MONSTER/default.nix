# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./nvidia.nix
    ./hardware-configuration.nix
  ];

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
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
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = ["ntfs"];

    # Silent Boot
    kernelParams = [
      "splash"
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "vt.global_cursor_default=0" # no cursor blinking
      "fbdev=1" # NVIDIA
      "video=DP-1:1920x1080@240"
      "video=DP-3:2560x1440@75"
      "video=HDMI-A-1:1920x1080@75"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;

    # Virtual Camera/Mic
    kernelModules = ["v4l2loopback" "snd-aloop" "sg"];
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      blacklist i2c_nvidia_gpu
      blacklist hid-logitech
      blacklist simpledrm
      blacklist nouveau
    ''; # NVIDIA
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

  hardware.hid-fanatecff.enable = true;

  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
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
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [anthy];
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
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    extraLayouts.cc1-thea = {
      description = "A CC1 optimized layout";
      languages = ["eng" "ger"];
      symbolsFile = ../../modules/cc1-thea;
    };
  };

  services.pcscd.enable = true;

  # nautilus on non-gnome
  services.gvfs.enable = true;
  # fix pinentry on non-gnome
  services.dbus.packages = with pkgs; [gcr];

  services.udev.packages = with pkgs; [
    oversteer
    android-udev-rules
  ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  services.getty.autologinUser = "theaninova";
  services.getty.extraArgs = ["--noclear" "--noissue" "--nonewline"];
  services.getty.loginOptions = "-p -f -- \\u"; # preserve environment
  programs.hyprland.enable = true;
  programs.hyprland.enableNvidiaPatches = true;
  users.users.theaninova = {
    isNormalUser = true;
    description = "Thea Schöbl";
    extraGroups = ["networkmanager" "wheel" "audio" "video" "dialout" "plugdev" "scanner" "lp" "input" "adbusers" "cdrom"];
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

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {fonts = ["JetBrainsMono" "Noto" "NerdFontsSymbolsOnly"];})
  ];

  programs.fish.enable = true;
  users.users.theaninova.shell = pkgs.fish;

  networking = {
    firewall = {
      allowedTCPPorts = [8100 5037];
      allowedUDPPorts = [50765];
    };

    networkmanager.enable = true;
    hosts = {
      "192.168.0.184" = ["kookaborrow"];
    };
  };

  fileSystems."/mnt/media" = {
    device = "kookaborrow:/media";
    fsType = "nfs";
    options = ["x-systemd-automount" "noauto"];
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
