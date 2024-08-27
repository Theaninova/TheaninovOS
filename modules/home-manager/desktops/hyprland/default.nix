{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  config = lib.mkIf osConfig.desktops.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
      settings = {
        env = [
          "XDG_SESSION_TYPE,wayland"
          "NIXOS_OZONE_WL,1"
          # Gnome file manager fix
          "GIO_EXTRA_MODULES,${pkgs.gnome.gvfs}/lib/gio/modules"
        ];
        exec-once = [
          "gnome-keyring-daemon --start --components=secrets"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ];
        input = {
          accel_profile = "flat";
          kb_layout = osConfig.services.xserver.xkb.layout;
          kb_variant = osConfig.services.xserver.xkb.variant;
        };
        bind = import ./keybinds.nix;
        bindm = import ./mousebinds.nix;
        bindr = [ "SUPER,SUPER_L,exec,pkill anyrun || anyrun" ];
        workspace = [
          "special:calc,border:false,gapsout:200,on-created-empty:[noanim;silent] kitty -e qalc"
        ];
        windowrulev2 =
          let
            firefoxPip = "class:^(firefox)$,title:^(Picture-in-Picture)$";
            firefoxPipInitial = "class:^(firefox)$,title:^(Firefox)$";
          in
          [
            "keepaspectratio,${firefoxPip}"
            "noborder,${firefoxPip}"
            "float,${firefoxPip}"
            "float,${firefoxPipInitial}"
            "pin,${firefoxPip}"
            "pin,${firefoxPipInitial}"
            "fullscreenstate 2 0,${firefoxPip}"
            "fullscreenstate 2 0,${firefoxPipInitial}"
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

            "float,class:^(zenity)$"
          ];
        misc = {
          layers_hog_keyboard_focus = false;
          disable_splash_rendering = true;
          disable_hyprland_logo = true;
          background_color = "rgb(000000)";
          force_default_wallpaper = 0;
        };
        layerrule = [
          "blur, anyrun"
          "ignorealpha 0.3, anyrun"
        ];
        decoration = {
          drop_shadow = "yes";
          shadow_range = 16;
          "col.shadow" = "rgba(00000044)";
        };
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
      package = pkgs.flameshot.overrideAttrs (
        final: prev: {
          cmakeFlags = [
            "-DUSE_WAYLAND_CLIPBOARD=1"
            "-DUSE_WAYLAND_GRIM=true"
          ];
          nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.libsForQt5.kguiaddons ];
        }
      );
      settings = {
        General = {
          uiColor = "#99d1db";
          showDesktopNotification = false;
          disabledTrayIcon = true;
        };
      };
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
      # qt/kde packages
      qt6.qtwayland
      qt5.qtwayland
      kdePackages.breeze-icons
      # gnome packages
      evince
      baobab
      gnome.gvfs
      gnome-keyring
      nautilus
      gnome-calendar
      gnome-characters
      gnome-contacts
      gnome-clocks
      gnome-calculator
      simple-scan
      eog
      geary
      ghex
      gnome-weather
      gnome-keyring
      gnome-disk-utility
      # fixes
      xorg.xrandr
    ];

    gtk = {
      enable = true;
      iconTheme = {
        name = "Tela";
        package = pkgs.tela-icon-theme;
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "qtct";
    };

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
