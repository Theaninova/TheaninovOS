{
  config,
  pkgs,
  ...
}: {
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
        # Potentially (?) fixes dialogs randomly closing again in IntelliJ
        # https://github.com/hyprwm/Hyprland/issues/1947
        "_JAVA_AWT_WM_NOREPARENTING,1"
        # Gnome file manager fix
        "GIO_EXTRA_MODULES,${pkgs.gnome.gvfs}/lib/gio/modules"
      ];
      exec-once = [
        "swww init"
        "ags"
        "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XAUTHORITY"
        "dbus-update-activation-environment DISPLAY WAYLAND_DISPLAY XAUTHORITY"
        "gnome-keyring-daemon --start --components=secrets"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
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
        kb_layout = "cc1-thea";
        numlock_by_default = true;
      };
      bind = import ./keybinds.nix;
      bindm = import ./mousebinds.nix;
      bindr = [
        "SUPER,SUPER_L,exec,ags -t overview"
        "SUPER,space,exec,(pkill fuzzel && hyprctl workspace previous) || (hyprctl workspace empty && fuzzel)"
      ];
      monitor = import ./monitors.nix;
      workspace = [
        "1,monitor:DP-1"
        "2,monitor:DP-1"
        "3,monitor:DP-1"
        "4,monitor:HDMI-A-1"
        "5,monitor:HDMI-A-1"
        "6,monitor:HDMI-A-1"
        "7,monitor:DP-3"
        "8,monitor:DP-3"
        "9,monitor:DP-3"
        "special:calc,border:false,gapsout:200,on-created-empty:[noanim;silent] kitty -e qalc"
      ];
      windowrule = [
        "pseudo,^(discord)$"
        "pseudo,^(Slack)$"
        "pseudo,^(steam)$"
        "monitor DP-3,^(discord)$"
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
        "noanim, .*"
        "xray 1, .*"

        "noanim, noanim"
        "blur, noanim"
        "blur, gtk-layer-shell"
        "ignorezero, gtk-layer-shell"
        "blur, launcher"
        "ignorealpha 0.3, launcher"
        "blur, notifications"
        "ignorealpha 0.3, notifications"
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
      ];
      decoration = {
        rounding = 20;
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
  programs.fuzzel = import ./fuzzel.nix;
  programs.kitty = import ./kitty.nix {inherit pkgs;};
  programs.wofi = import ./wofi.nix;

  services.udiskie.enable = true;
  services.udiskie.tray = "never";

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

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };

    file.profile = {
      enable = true;
      target = ".zprofile"; # change to .profile if you're not using zsh
      text =
        /*
        sh
        */
        ''
          Hyprland && echo "goodbye" && exit 0 \
          || echo "$? couldn't launch Hyprland" && tty | grep tty1 \
          && echo "refusing to autologin without Hyprland on tty1" && exit 0 \
          || echo "not on tty1, letting in"
        '';
    };

    file.".config/hypr/shaders" = {
      source = ./hypr/shaders;
      recursive = true;
    };
  };
}
