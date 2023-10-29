{ config, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    settings = {
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "NIXOS_OZONE_WL,1"
        # Fixes black screen on Jellyfin
        # https://github.com/jellyfin/jellyfin-media-player/issues/165#issuecomment-1569842393
        "QT_QPA_PLATFORM,xcb"
      ];
      exec-once = [
        "ags"
        "swww init"
        "swww img ~/Pictures/Wallpapers/wallpaper.jpg"
      ];
      general = {
        gaps_in = 4;
        gaps_out = 5;
        border_size = 1;

        "col.active_border" = "rgba(0DB7D4FF)";
        "col.inactive_border" = "rgba(31313600)";

        layout = "dwindle";
      };
      dwindle.preserve_split = true;
      dwindle.pseudotile = true;
      input = {
        accel_profile = "flat";
      };
      bind = import ./keybinds.nix;
      bindm = import ./mousebinds.nix;
      bindr = [
        "SUPER,SUPER_L,exec,ags -t overview"
        "SUPER,space,exec,(pkill fuzzel && hyprctl workspace previous) || (hyprctl workspace empty && fuzzel)"
      ];
      monitor = import ./monitors.nix;
      windowrule = [
        "pseudo,^(discord)$"
        "monitor DP-3,^(discord)$"
      ];
      layerrule = import ./layerrules.nix;
      decoration = import ./decoration.nix;
    };
  };

  # services.dunst = import ./dunst.nix;
  
  programs.ags = {
    enable = true;
    configDir = ./ags;
  };
  programs.fuzzel = import ./fuzzel.nix;
  # programs.alacritty.enable = true;
  programs.fish.enable = true;
  programs.foot = import ./foot.nix;
  # programs.waybar = import ./waybar.nix;
  programs.wofi = import ./wofi.nix;
  programs.swaylock = import ./swaylock.nix;

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # fonts
    noto-fonts
    # essentials
    xwaylandvideobridge
    hyprpicker
    grim
    slurp
    wl-clipboard
    /* TODO: (flameshot.overrideAttrs(prev: {
      nativeBuildInputs = prev.nativeBuildInputs ++ [ git grim ];
      cmakeFlags = [
        "-DUSE_WAYLAND_CLIPBOARD=1"
        "-DUSE_WAYLAND_GRIM=true"
      ];
    }))*/
    # wttrbar
    swww
    # ags
    glib
    brightnessctl
    ydotool
    sassc
    # gnome packages
    gnome.nautilus
  ];

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "capitaine-cursors";
      package = pkgs.capitaine-cursors;
    };
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };

  home.file.profile = {
    enable = true;
    target = ".zprofile"; # change to .profile if you're not using zsh
    text = ''
      Hyprland && echo "goodbye" && exit 0 \
        || echo "$? couldn't launch Hyprland" && tty | grep tty1 \
        && echo "refusing to autologin without Hyprland on tty1" && exit 0 \
        || echo "not on tty1, letting in"
    '';
  };

  home.file.".config/hypr/shaders" = {
    source = ./hypr/shaders;
    recursive = true;
  };
}

