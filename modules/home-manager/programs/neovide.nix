{ pkgs, ... }:
{
  home.packages = [ pkgs.neovide ];
  xdg.configFile."neovide/config.toml".source = (pkgs.formats.toml { }).generate "neovide" {
    maximized = false;
    fork = true;
    font = {
      normal = [ "FiraCode Nerd Font" ];
      size = 12;
      edging = "subpixelantialias";
      hinting = "full";
      features."FiraCode Nerd Font" = [
        "+zero"
        "+onum"
        "+ss04"
        "+cv19"
        "+cv23"
        "+ss09"
        "+cv26"
        "+ss06"
        "+ss10"
      ];
    };
    box-drawing = {
      mode = "native";
      sizes.default = [
        1
        3
      ];
    };
  };
  wayland.windowManager.hyprland.settings.windowrulev2 = [
    # For some reason it really wants to be maximized
    "suppressevent maximize,class:^(neovide)$"
  ];
  programs.nixvim = {
    globals = {
      neovide_text_gamma = 0.0;
      neovide_text_contrast = 0.0;
      neovide_position_animation_length = 0.3;
      neovide_remember_window_size = false;
      neovide_hide_mouse_when_typing = true;
      experimental_layer_grouping = true;
      neovide_cursor_vfx_mode = "pixiedust";
      neovide_cursor_trail_size = 0.7;
    };
  };
}
