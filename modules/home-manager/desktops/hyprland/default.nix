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
  cfg = osConfig.desktops.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        general = {
          allow_tearing = true;
          layout = lib.mkIf cfg.scrolling "scrolling";
        };
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

          "SUPER,f,workspace,r-1"
          "SUPER,h,workspace,r+1"
          "SUPER_SHIFT,f,movetoworkspace,r-1"
          "SUPER_SHIFT,h,movetoworkspace,r+1"
        ]
        ++ (
          if cfg.scrolling then
            [
              "SUPER,up,layoutmsg,focus u"
              "SUPER,down,layoutmsg,focus d"
              "SUPER,right,layoutmsg,focus r"
              "SUPER,left,layoutmsg,focus l"

              "SUPER_SHIFT,up,layoutmsg,movewindowto u"
              "SUPER_SHIFT,down,layoutmsg,movewindowto d"
              "SUPER_SHIFT,left,layoutmsg,swapcol l"
              "SUPER_SHIFT,right,layoutmsg,swapcol r"

              "SUPER,mouse_up,layoutmsg,focus r"
              "SUPER,mouse_down,layoutmsg,focus l"
            ]
          else
            [
              "SUPER_SHIFT,up,movewindow,u"
              "SUPER_SHIFT,down,movewindow,d"
              "SUPER_SHIFT,left,movewindow,l"
              "SUPER_SHIFT,right,movewindow,r"

              "SUPER,up,movefocus,u"
              "SUPER,down,movefocus,d"
              "SUPER,left,movefocus,l"
              "SUPER,right,movefocus,r"

              "SUPER,mouse_up,workspace,r+1"
              "SUPER,mouse_down,workspace,r-1"
            ]
        );
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
        decoration.border_part_of_window = false;
        input.touchpad.natural_scroll = true;
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
      xrandr
    ];

    gtk = {
      enable = true;
      font.name = builtins.elemAt osConfig.fonts.fontconfig.defaultFonts.sansSerif 0;
    };
    qt.enable = true;

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
    };
  };
}
