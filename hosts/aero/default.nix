{
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  nix = {
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
    initrd = {
      availableKernelModules = [ "tpm_tis" ];
      systemd = {
        enable = true;
        tpm2.enable = true;
      };
      luks.devices."luks-52ef6970-af53-43e6-8b2f-0ff95dad2d23".device =
        "/dev/disk/by-uuid/52ef6970-af53-43e6-8b2f-0ff95dad2d23";
    };
  };

  xdg.forced-compliance.enable = true;

  usecases = {
    gaming.enable = true;
    "3d-printing".enable = true;
    development = {
      enable = true;
      svelte.enable = true;
    };
  };

  shell.components = {
    firefox-pip.enable = true;
    gnome-keyring.enable = true;
    grimblast.enable = true;
    hyprpicker.enable = true;
    kde-connect.enable = true;
    kitty.enable = true;
    swaync.enable = true;
    walker.enable = true;
    waybar = {
      enable = true;
      mobile = true;
    };
  };
  desktops = {
    hyprland.enable = true;
  };
  locale.preset.theaninova.enable = true;

  services.xserver = {
    xkb = {
      #variant = "altgr-intl";
      #layout = "us";
      layout = "de";
    };
    videoDrivers = [ "nvidia" ];
  };

  hardware = {
    audio.preset.pipewire.enable = true;
    cc1.enable = true;

    nvidia = {
      preset.proprietary.enable = true;
      prime = {
        reverseSync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  fonts = {
    fira-code.enable = true;
    noto-sans.enable = true;
    open-dyslexic = {
      enable = true;
      default = true;
    };
    nerd-fonts.enable = true;
  };

  programs.zsh.enable = true;
  security.sudo.configFile = ''
    Defaults env_reset,pwfeedback,passprompt="󰟵  "
  '';
  security.tpm2.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "scanner"
      "lp"
      "storage"
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
    usbimager
    uhubctl
    bluetuith
    pciutils
    htop
    unar
    gnupg
    libdrm
    alsa-utils
    graphicsmagick
    ffmpeg
    nfs-utils
    opensc
    openssl
    # secure boot / tmp2
    sbctl
    tpm2-tss
    # Essential command line apps
    neovim
    mc
    git
    p7zip
    fzf
    eza
  ];

  networking = {
    firewall.allowedUDPPorts = [ 50765 ];

    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-openconnect ];
    };
  };

  system.stateVersion = "24.11";
}
