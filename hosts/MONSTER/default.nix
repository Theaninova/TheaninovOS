{ pkgs, username, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix = {
    package = pkgs.nixVersions.git;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
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
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  xdg.forced-compliance.enable = true;

  usecases = {
    gaming.enable = true;
    "3d-printing".enable = true;
    development = {
      enable = true;
      angular.enable = true;
      android.enable = true;
      svelte.enable = true;
      docker.enable = true;
    };
  };

  shell.components = {
    waybar.enable = true;
    dunst.enable = true;
  };
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  desktops = {
    hyprland.enable = true;
    # gamescope.enable = true;
  };
  locale.preset.theaninova.enable = true;

  services.xserver.xkb.variant = "altgr-intl";
  services.xserver.xkb.layout = "us";
  hardware = {
    amdgpu.preset.default.enable = true;
    audio.preset.pipewire.enable = true;
    cc1.enable = true;
    q3279vwf.enable = true;
    virtual-camera.enable = true;
    hid-fanatecff.enable = true;

    enableAllFirmware = true;
    sane.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
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

  services.udev.packages = with pkgs; [ android-udev-rules ];

  programs.zsh.enable = true;
  security.sudo.configFile = ''
    Defaults env_reset,pwfeedback,passprompt="󰟵  "
  '';
  users.defaultUserShell = pkgs.zsh;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "scanner"
      "lp"
      "networkmanager"
      "audio"
      "video"
      "plugdev"
      "cdrom"
      "kvm"
    ];
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
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
    # docker
  ];

  networking = {
    firewall.allowedUDPPorts = [ 50765 ];

    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-openconnect ];
    };
  };

  system.stateVersion = "24.05";
}
