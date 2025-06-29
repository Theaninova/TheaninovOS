{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  hypr-cycle = pkgs.writeShellApplication {
    name = "hypr-cycle";
    text = ''
      WORKSPACE=$(hyprctl activeworkspace -j | jq -r '.id')
      WINDOW=$(hyprctl activewindow -j | jq -r '.address')
      hyprctl clients -j | jq -r "map(select(.workspace.id == $WORKSPACE) | select(.class == \"$1\") | .address | select(. != $WINDOW)) | .[0]" 
    '';
  };
in
{
  config = lib.mkIf osConfig.desktops.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        general.allow_tearing = true;
        input = {
          accel_profile = "flat";
          kb_layout = osConfig.services.xserver.xkb.layout;
          kb_variant = osConfig.services.xserver.xkb.variant;
        };
        bind = [
          "SUPER,C,killactive"
          "SUPER,P,togglefloating,"
          "SUPER,P,pin,"
          "SUPER,D,fullscreen,1"
          "SUPER,V,fullscreen,0"

          "SUPER_SHIFT,up,movewindow,u"
          "SUPER_SHIFT,down,movewindow,d"
          "SUPER_SHIFT,left,movewindow,l"
          "SUPER_SHIFT,right,movewindow,r"

          "SUPER,up,movefocus,u"
          "SUPER,down,movefocus,d"
          "SUPER,left,movefocus,l"
          "SUPER,right,movefocus,r"

          "SUPER,f,workspace,r-1"
          "SUPER,h,workspace,r+1"
          "SUPER_SHIFT,f,movetoworkspace,r-1"
          "SUPER_SHIFT,h,movetoworkspace,r+1"
          "SUPER,mouse_up,workspace,r+1"
          "SUPER,mouse_down,workspace,r-1"
        ];
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];
        misc = {
          layers_hog_keyboard_focus = false;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          vrr = lib.mkDefault 2;
        };
        input.touchpad.natural_scroll = true;
        gestures.workspace_swipe = true;
      };
    };

    services.udiskie = {
      enable = true;
      tray = "never";
    };

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # fonts
      noto-fonts
      # qt/kde packages
      qt6.qtwayland
      qt5.qtwayland
      kdePackages.breeze-icons
      # gnome packages
      evince
      baobab
      gnome.gvfs
      nautilus
      simple-scan
      eog
      ghex
      gnome-disk-utility
      # fixes
      xorg.xrandr
    ];

    gtk.enable = true;
    qt.enable = true;

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };
  };
}
