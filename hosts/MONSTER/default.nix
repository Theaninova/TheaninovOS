{ config, pkgs, username, ... }: {
  imports = [ ./hardware-configuration.nix ];

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
    quiet.enable = true;

    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "ntfs" ];
  };

  desktops.hyprland.enable = true;
  locale.preset.theaninova.enable = true;

  hardware = {
    amdgpu.preset.default.enable = true;
    audio.preset.pipewire.enable = true;
    cc1.enable = true;
    fv43u.enable = true;
    virtual-camera.enable = true;
    # https://github.com/NixOS/nixpkgs/pull/300682
    # hid-fanatecff.enable = true;
  };

  fonts = {
    fira-code = {
      enable = true;
      default = true;
    };
    noto-sans = {
      enable = true;
      default = true;
    };
    nerdfonts.enable = true;
  };

  services.airprint.enable = true;

  services.udev.packages = with pkgs; [ oversteer android-udev-rules ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  programs.fish.enable = true;
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
      "plugdev"
      "input"
      "adbusers"
      "cdrom"
    ];
  };

  # List packages installed in system profile. To search, run:
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

  system.stateVersion = "23.05";
}
