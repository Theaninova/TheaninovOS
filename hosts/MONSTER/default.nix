{ pkgs, username, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader.timeout = 0;

    quiet.enable = true;

    kernelPackages = pkgs.linuxPackages_xanmod_stable;
    kernelModules = [ "sg" ];

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
    localai.enable = true;
    "3d-printing".enable = true;
    development = {
      enable = true;
      angular.enable = true;
      android.enable = true;
      svelte.enable = true;
      docker.enable = true;
    };
    windows-vm.enable = true;
  };

  shell.components = {
    firefox-pip.enable = true;
    grimblast.enable = true;
    gnome-keyring.enable = true;
    hyprpicker.enable = true;
    kde-connect.enable = true;
    kitty.enable = true;
    swaync.enable = true;
    walker.enable = true;
    waybar = {
      enable = true;
      home-assistant = true;
    };
  };
  desktops.hyprland = {
    enable = true;
    scrolling = true;
  };
  locale.preset.theaninova.enable = true;
  services = {
    xserver.xkb.variant = "altgr-intl";
    xserver.xkb.layout = "us";

    airprint.enable = true;

    udev.packages = with pkgs; [
      usb-sniffer
    ];
  };

  hardware = {
    amdgpu.preset.default.enable = true;
    audio = {
      preset.pipewire.enable = true;
      audio-share = {
        enable = true;
        partner = {
          ip = "192.168.0.51";
          name = "Luci";
          combine = "astro-a50-eq-harman-in";
        };
      };
    };
    cc1.enable = true;
    fv43u.enable = true;
    astro-a50.enable = true;
    # virtual-camera.enable = true;
    # hid-fanatecff.enable = true;

    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  virtualisation.oci-containers.containers = {
    /*
      statech = {
        image = "eclipse-temurin:21-jre";
        volumes = [ "/home/theaninova/.config/statech:/statech" ];
        environment = { };
        ports = [ "25565:25565" ];
        workdir = "/statech";
        entrypoint = "/bin/bash";
        cmd = [ "start.sh" ];
        extraOptions = [ "--network=host" ];
      };
    */
    /*
      craftoria = {
        image = "eclipse-temurin:21-jre";
        volumes = [ "/home/theaninova/.config/craftoria:/craftoria" ];
        environment = { };
        ports = [ "25565:25565" ];
        workdir = "/craftoria";
        entrypoint = "/bin/bash";
        cmd = [ "startserver.sh" ];
        extraOptions = [ "--network=host" ];
      };
    */
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
    nerd-fonts.enable = true;
  };

  programs = {
    zsh.enable = true;
    wireshark = {
      enable = false;
      package = pkgs.wireshark;
      usbmon.enable = true;
    };
    nix-ld = {
      enable = true;
      enableRecommendedLibraries = true;
    };
  };

  security.sudo.configFile = ''
    Defaults env_reset,pwfeedback,passprompt="󰟵  "
  '';
  users.defaultUserShell = pkgs.zsh;
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wireshark"
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
    nix-output-monitor
    alacritty
    usbutils
    usbimager
    uhubctl
    usb-sniffer
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
    # Essential command line apps
    neovim
    mc
    git
    p7zip
    fzf
    eza
    # docker
    ausweisapp
  ];

  networking = {
    firewall = {
      allowedTCPPorts = [
        25565
        5173
      ];
      allowedUDPPorts = [
        25565
        50765

        # AusweisApp
        24727
      ];
      /*
        allowedUDPPortRanges = [
          {
            from = 1;
            to = 65535;
          }
        ];
      */
    };

    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-openconnect ];
    };
  };

  system.stateVersion = "24.05";
}
