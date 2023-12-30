{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./darkman.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
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
        # Potentially (?) fixes dialogs randomly closing again in IntelliJ
        # https://github.com/hyprwm/Hyprland/issues/1947
        "_JAVA_AWT_WM_NOREPARENTING,1"
        # Gnome file manager fix
        "GIO_EXTRA_MODULES,${pkgs.gnome.gvfs}/lib/gio/modules"
      ];
      exec-once = [
        "swww init"
        "ags"
        "waybar"
        "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XAUTHORITY"
        "dbus-update-activation-environment DISPLAY WAYLAND_DISPLAY XAUTHORITY"
        "gnome-keyring-daemon --start --components=secrets"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];
      general = {
        gaps_in = 16;
        gaps_out = 16;
        border_size = 1;

        "col.active_border" = "rgba(0DB7D4FF)";
        "col.inactive_border" = "rgba(31313600)";

        layout = "dwindle";
      };
      dwindle.preserve_split = true;
      dwindle.pseudotile = true;
      input = {
        accel_profile = "flat";
        kb_layout = "cc1-thea";
        # kb_options = "grp:alt_shift_toggle";
        numlock_by_default = true;
      };
      bind = import ./keybinds.nix;
      bindm = import ./mousebinds.nix;
      bindr = [
        "SUPER,SUPER_L,exec,pkill anyrun || anyrun"
      ];
      monitor = import ./monitors.nix;
      workspace = [
        "100,monitor:DP-1,default:true"
        "200,monitor:HDMI-A-1,default:true"
        "300,monitor:DP-3:default:true"
        "special:calc,border:false,gapsout:200,on-created-empty:[noanim;silent] kitty -e qalc"
      ];
      windowrule = [
        "pseudo,^(steam)$"
      ];
      windowrulev2 = [
        # Games
        ## AC2
        "monitor DP-3,class:^(steam_app_805550)$"
        "fullscreen,class:^(steam_app_805550)$"
        "immediate,class:^(steam_app_805550)$"
        # IntelliJ focus fixes
        "windowdance,class:^(jetbrains-.*)$"
        "dimaround,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
        "center,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
        "noanim,class:^(jetbrains-.*)$,title:^(win.*)$"
        "noinitialfocus,class:^(jetbrains-.*)$,title:^(win.*)$"
        "rounding 0,class:^(jetbrains-.*)$,title:^(win.*)$"
        # pinentry
        "dimaround,class:^(gcr-prompter)$"
        "noborder,class:^(gcr-prompter)$"
        "rounding 10,class:^(gcr-prompter)$"
        "animation slide,class:^(gcr-prompter)$"
      ];
      layerrule = [
        "noanim, noanim"
        "blur, noanim"
        "blur, gtk-layer-shell"
        "ignorezero, gtk-layer-shell"
        "blur, launcher"
        "ignorealpha 0.3, launcher"
        "blur, notifications"
        "ignorealpha 0.3, notifications"
        "blur, anyrun"
        "ignorealpha 0.3, anyrun"
        # ags
        "blur, bar"
        "ignorealpha 0.3, bar"
        "blur, corner.*"
        "ignorealpha 0.3, corner.*"
        "blur, indicator.*"
        "ignorealpha 0.3, indicator.*"
        "blur, overview"
        "ignorealpha 0.3, overview"
        "xray 0, overview"
        "blur, cheatsheet"
        "ignorealpha 0.3, cheatsheet"
        "blur, sideright"
        "ignorealpha 0.3, sideright"
        "blur, sideleft"
        "ignorealpha 0.3, sideleft"
        "blur, indicatorundefined"
        "ignorealpha 0.3, indicatorundefined"
        "blur, osk"
        "ignorealpha 0.3, osk"
        "blur, session"
      ];
      animation = [
        "specialWorkspace,1,4,default,fade"
        "fade,1,1,default"
      ];
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          xray = false;

          size = 6;
          passes = 4;
        };

        drop_shadow = true;
        shadow_range = 15;
        shadow_render_power = 6;
        "col.shadow" = "rgba(00000044)";
      };
    };
  };

  programs.ags = {
    enable = true;
    configDir = ./ags;
  };
  programs.kitty = import ./kitty.nix {inherit pkgs;};
  programs.anyrun = import ./anyrun.nix {inherit pkgs;};
  programs.waybar = import ./waybar.nix {inherit pkgs;};
  programs.foot.enable = true;
  services.udiskie.enable = true;
  services.udiskie.tray = "never";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (callPackage ../../../overlays/wezterm {
      Cocoa = pkgs.Cocoa;
      CoreGraphics = pkgs.CoreGraphics;
      Foundation = pkgs.Foundation;
      System = pkgs.System;
      UserNotifications = pkgs.UserNotifications;
    })
    libsForQt5.konsole
    # fonts
    noto-fonts
    # essentials
    xwaylandvideobridge
    hyprpicker
    grim
    slurp
    wl-clipboard
    polkit_gnome
    xdg-desktop-portal-gtk
    /*
       TODO: (flameshot.overrideAttrs(prev: {
      nativeBuildInputs = prev.nativeBuildInputs ++ [ git grim ];
      cmakeFlags = [
        "-DUSE_WAYLAND_CLIPBOARD=1"
        "-DUSE_WAYLAND_GRIM=true"
      ];
    }))
    */
    swww
    # ags
    glib
    brightnessctl
    ydotool
    sassc
    # gnome packages
    evince
    gnome.gvfs
    gnome.gnome-keyring
    gnome.nautilus
    gnome.gnome-calendar
    gnome.gnome-characters
    gnome.gnome-contacts
    gnome.gnome-clocks
    gnome.gnome-calculator
    gnome.simple-scan
    gnome.gedit
    gnome.eog
    gnome.geary
    gnome.ghex
    gnome.gnome-weather
    gnome.gnome-keyring
    gnome.gnome-disk-utility
    # fixes
    xorg.xrandr
  ];

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Tela";
      package = pkgs.tela-icon-theme;
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  programs.fish.loginShellInit =
    /*
    fish
    */
    ''
      Hyprland && echo "goodbye" && exit 0 \
      || echo "$status couldn't launch Hyprland" && tty | grep tty1 \
      && echo "refusing to autologin without Hyprland on tty1" && exit 0 \
      || echo "not on tty1, letting in"
    '';

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };

    file.".config/hypr/shaders" = {
      source = ./hypr/shaders;
      recursive = true;
    };

    file.".config/wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
  };
}
