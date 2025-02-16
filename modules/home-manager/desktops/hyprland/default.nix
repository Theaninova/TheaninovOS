{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  config = lib.mkIf osConfig.desktops.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
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

          "SUPER,1,workspace,1"
          "SUPER,2,workspace,2"
          "SUPER,3,workspace,3"
          "SUPER,4,workspace,4"
          "SUPER,5,workspace,5"
          "SUPER,6,workspace,6"
          "SUPER,7,workspace,7"
          "SUPER,8,workspace,8"
          "SUPER,9,workspace,9"

          "SUPER_SHIFT,1,movetoworkspace,1"
          "SUPER_SHIFT,2,movetoworkspace,2"
          "SUPER_SHIFT,3,movetoworkspace,3"
          "SUPER_SHIFT,4,movetoworkspace,4"
          "SUPER_SHIFT,5,movetoworkspace,5"
          "SUPER_SHIFT,6,movetoworkspace,6"
          "SUPER_SHIFT,7,movetoworkspace,7"
          "SUPER_SHIFT,8,movetoworkspace,8"
          "SUPER_SHIFT,9,movetoworkspace,9"
        ];
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];
        misc = {
          layers_hog_keyboard_focus = false;
        };
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
