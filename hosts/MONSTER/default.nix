{ pkgs, username, ... }:
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
    waybar.enable = true;
  };
  desktops = {
    hyprland.enable = true;
  };
  locale.preset.theaninova.enable = true;

  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      rocmOverrideGfx = "10.3.0";
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        rastertokpsl-re
      ];
    };

    xserver.xkb.variant = "altgr-intl";
    xserver.xkb.layout = "us";

    airprint.enable = true;

    udev.packages = with pkgs; [
      android-udev-rules
      usb-sniffer
    ];
  };

  hardware = {
    amdgpu.preset.default.enable = true;
    audio.preset.pipewire.enable = true;
    cc1.enable = true;
    fv43u.enable = true;
    astro-a50.enable = true;
    # virtual-camera.enable = true;
    # hid-fanatecff.enable = true;

    enableAllFirmware = true;
    sane.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  virtualisation.oci-containers.containers = {
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
      enable = true;
      package = pkgs.wireshark;
      usbmon.enable = true;
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
  ];

  networking = {
    firewall = {
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [
        25565
        50765
      ];
    };

    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-openconnect ];
    };
  };

  system.stateVersion = "24.05";
}
