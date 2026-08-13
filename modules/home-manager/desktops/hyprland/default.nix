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
  bind = bind: action: {
    _args = [
      bind
      (lib.generators.mkLuaInline action)
    ];
  };
  bindm = bind: action: {
    _args = [
      bind
      (lib.generators.mkLuaInline action)
      { mouse = true; }
    ];
  };
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      settings = {
        config = {
          general = {
            allow_tearing = true;
            layout = lib.mkIf cfg.scrolling "scrolling";
          };
          input = {
            accel_profile = "flat";
            kb_layout = osConfig.services.xserver.xkb.layout;
            kb_variant = osConfig.services.xserver.xkb.variant;
            touchpad.natural_scroll = true;
          };
          misc = {
            layers_hog_keyboard_focus = false;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            vrr = lib.mkDefault 2;
            enable_swallow = false;
            swallow_regex = "^kitty$";
          };
          binds.scroll_event_delay = 0;
          decoration.border_part_of_window = false;
        };
        bind = [
          (bind "SUPER + C" "hl.dsp.window.close()")
          (bind "SUPER + P" ''
            function()
              hl.dsp.window.float()
              hl.dsp.window.pin()
            end
          '')
          (bind "SUPER + D" "hl.dsp.window.fullscreen({ mode = 'maximized' })")
          (bind "SUPER + V" "hl.dsp.window.fullscreen({ mode = 'fullscreen' })")

          (bind "SUPER + F" "hl.dsp.focus({ workspace = 'r-1' })")
          (bind "SUPER + H" "hl.dsp.focus({ workspace = 'r+1' })")
          (bind "SUPER + SHIFT + F" "hl.dsp.window.move({ workspace = 'r-1' })")
          (bind "SUPER + SHIFT + H" "hl.dsp.window.move({ workspace = 'r+1' })")

          (bindm "SUPER + mouse:272" "hl.dsp.window.drag()")
          (bindm "SUPER + mouse:273" "hl.dsp.window.resize()")
        ]
        ++ (
          if cfg.scrolling then
            [
              (bind "SUPER + SHIFT + LEFT" "hl.dsp.layout('swapcol l')")
              (bind "SUPER + SHIFT + RIGHT" "hl.dsp.layout('swapcol r')")

              (bind "SUPER + UP" "hl.dsp.layout('focus u')")
              (bind "SUPER + DOWN" "hl.dsp.layout('focus d')")
              (bind "SUPER + LEFT" "hl.dsp.layout('focus l')")
              (bind "SUPER + RIGHT" "hl.dsp.layout('focus r')")

              (bind "SUPER + mouse_up" "hl.dsp.layout('focus l')")
              (bind "SUPER + mouse_down" "hl.dsp.layout('focus r')")
            ]
          else
            [
              (bind "SUPER + SHIFT + UP" "hl.dsp.window.move({ direction = 'up' })")
              (bind "SUPER + SHIFT + DOWN" "hl.dsp.window.move({ direction = 'down' })")
              (bind "SUPER + SHIFT + LEFT" "hl.dsp.window.move({ direction = 'left' })")
              (bind "SUPER + SHIFT + RIGHT" "hl.dsp.window.move({ direction = 'right' })")

              (bind "SUPER + UP" "hl.dsp.focus({ direction = 'up' })")
              (bind "SUPER + DOWN" "hl.dsp.focus({ direction = 'down' })")
              (bind "SUPER + LEFT" "hl.dsp.focus({ direction = 'left' })")
              (bind "SUPER + RIGHT" "hl.dsp.focus({ direction = 'right' })")

              (bind "SUPER + mouse_up" "hl.dsp.focus({ workspace = 'r-1' })")
              (bind "SUPER + mouse_down" "hl.dsp.focus({ workspace = 'r+1' })")
            ]
        );
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
