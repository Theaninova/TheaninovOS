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
      ];
      exec-once = [
        "dunst"
        "waybar"
        "swww init"
        "swww img ~/Pictures/Wallpapers/wallpaper.jpg --transition-type center"
      ];
      input = {
        accel_profile = "flat";
      };
      bind = import ./keybinds.nix;
      bindm = import ./mousebinds.nix;
      monitor = import ./monitors.nix;
      windowrule = [
        "pseudo,^(alacritty)$"
      ];
    };
  };

  services.dunst = import ./dunst.nix;
  
  programs.alacritty.enable = true;
  programs.waybar = import ./waybar.nix;
  programs.wofi = import ./wofi.nix;

  home.packages = with pkgs; [
    xwaylandvideobridge
    hyprpicker
    wttrbar
    swww
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.adw-gtk3;
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
}

