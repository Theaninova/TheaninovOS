{ config, pkgs, lib, osConfig, ... }: {
  config = lib.mkIf osConfig.desktops.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      settings = {
        env = [
          "LIBVA_DRIVER_NAME,nvidia"
          "XDG_SESSION_TYPE,wayland"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "WLR_NO_HARDWARE_CURSORS,1"
          "NIXOS_OZONE_WL,1"
          # Gnome file manager fix
          "GIO_EXTRA_MODULES,${pkgs.gnome.gvfs}/lib/gio/modules"
        ];
        exec-once = [
          "systemctl --user start hyprland-session.target"
          "gnome-keyring-daemon --start --components=secrets"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ];
        general = {
          layout = "master";
          resize_on_border = true;
        };
        master = {
          orientation = "center";
          new_is_master = true;
          always_center_master = true;
          mfact = 0.4;
        };
        input = {
          accel_profile = "flat";
          kb_layout = "cc1-thea";
        };
        bind = import ./keybinds.nix;
        bindm = import ./mousebinds.nix;
        bindr = [ "SUPER,SUPER_L,exec,pkill anyrun || anyrun" ];
        monitor = [ "DP-1,highrr,0x0,1" "DP-1,addreserved,250,0,0,0" ];
        workspace = [
          "special:calc,border:false,gapsout:200,on-created-empty:[noanim;silent] kitty -e qalc"
        ];
        windowrulev2 = let
          firefoxPip = "class:^(firefox)$,title:^(Picture-in-Picture)$";
          firefoxPipInitial = "class:^(firefox)$,title:^(Firefox)$";
        in [
          "keepaspectratio,${firefoxPip}"
          "noborder,${firefoxPip}"
          "float,${firefoxPip}"
          "float,${firefoxPipInitial}"
          "pin,${firefoxPip}"
          "pin,${firefoxPipInitial}"
          "fakefullscreen,${firefoxPip}"
          "fakefullscreen,${firefoxPipInitial}"
          "move 22 72,${firefoxPip}"
          "move 22 72,${firefoxPipInitial}"
          # For some reason it really wants to be maximized
          "suppressevent maximize,class:^(neovide)$"
          # pinentry
          "dimaround,class:^(gcr-prompter)$"
          "noborder,class:^(gcr-prompter)$"
          "rounding 10,class:^(gcr-prompter)$"
          "animation slide,class:^(gcr-prompter)$"
          # Flameshot fixes
          "float,class:^(flameshot)$"
          "animation fade,class:^(flameshot)$"
        ];
        xwayland.force_zero_scaling = true;
        misc = {
          layers_hog_keyboard_focus = false;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          vrr = 1;
        };
        layerrule = [ "blur, anyrun" "ignorealpha 0.3, anyrun" ];
        decoration = {
          drop_shadow = "yes";
          shadow_range = 16;
          "col.shadow" = "rgba(00000044)";

          dim_inactive = false;

          blur = {
            enabled = true;
            size = 8;
            passes = 3;
            noise = 1.0e-2;
            contrast = 0.9;
            brightness = 0.8;
          };
        };
        opengl.nvidia_anti_flicker = true;
        animations = {
          enabled = "yes";
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 5, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };
      };
    };

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
    services.flameshot = {
      enable = true;
      package = pkgs.flameshot.overrideAttrs (final: prev: {
        cmakeFlags = [ "-DUSE_WAYLAND_CLIPBOARD=1" "-DUSE_WAYLAND_GRIM=true" ];
        nativeBuildInputs = prev.nativeBuildInputs
          ++ [ pkgs.libsForQt5.kguiaddons ];
      });
      settings = {
        General = {
          uiColor = "#99d1db";
          showDesktopNotification = false;
          disabledTrayIcon = true;
        };
      };
    };

    services.darkman = let
      wallpaperPath = "${config.home.homeDirectory}/.local/state/wallpaper.jpg";
    in {
      enable = false;
      settings = {
        lat = 52.52;
        lng = 13.405;
      };
      darkModeScripts = {
        kitty-theme = ''
          ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all --config-file-name ${config.home.homeDirectory}/.config/kitty/current-colors.conf Catppuccin-Frappe
        '';
      };
      lightModeScripts = {
        kitty-theme = ''
          ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all --config-file-name ${config.home.homeDirectory}/.config/kitty/current-colors.conf Catppuccin-Latte
        '';
      };
    };
    programs.ags = {
      enable = true;
      configDir = ./ags;
    };
    xdg.configFile.ags.onChange = ''
      ${pkgs.procps}/bin/pkill -u $USER -USR2 ags || true
    '';
    systemd.user.services.ags = {
      Unit = {
        Description = "ags";
        PartOf = [ "graphical-session.target" "tray.target" ];
      };
      Service = {
        ExecStart = "${pkgs.ags}/bin/ags";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "always";
        KillMode = "mixed";
        Environment = "PATH=/run/current-system/sw/bin/:${
            with pkgs;
            lib.makeBinPath [
              swww
              sassc
              glib
              brightnessctl
              ydotool
              kitty
              hyprpicker
            ]
          }";
      };
      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
    programs.kitty = import ./kitty.nix { inherit pkgs; };
    programs.anyrun = import ./anyrun.nix { inherit pkgs; };
    services.udiskie.enable = true;
    services.udiskie.tray = "never";

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # fonts
      noto-fonts
      # essentials
      hyprpicker
      grim
      slurp
      wl-clipboard
      polkit_gnome
      xdg-desktop-portal-gtk
      # qt/kde packages
      qt6.qtwayland
      qt5.qtwayland
      kdePackages.breeze-icons
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
      #gtk3.extraCss = builtins.readFile ./gtk.css;
      #gtk4.extraCss = builtins.readFile ./gtk.css;
      iconTheme = {
        name = "Tela";
        package = pkgs.tela-icon-theme;
      };
    };
    qt = {
      enable = true;
      platformTheme = "qtct";
    };

    programs.fish.loginShellInit =
      # fish
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
    };
  };
}