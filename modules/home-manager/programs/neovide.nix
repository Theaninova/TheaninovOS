{ pkgs, ... }:
{
  home.packages = [
    (pkgs.neovide.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "neovide";
        repo = "neovide";
        rev = "1db63d93b18cc1eb5ac5b3e67b3ca63505f10800";
        hash = "sha256-iBGDxOro1yd98d5XPIw824dapuHDimuP27f/nKbh6qo=";
      };
    })
  ];
  xdg.configFile."neovide/config.toml".source = (pkgs.formats.toml { }).generate "neovide" {
    maximized = false;
    fork = true;
    font = {
      normal = [ "FiraCode Nerd Font" ];
      size = 12.75;
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
  };
  programs.nixvim = {
    globals = {
      neovide_text_gamma = 0.0;
      neovide_text_contrast = 0.0;
      neovide_position_animation_length = 0.3;
      neovide_remember_window_size = false;
      neovide_hide_mouse_when_typing = true;
      experimental_layer_grouping = true;
      neovide_cursor_vfx_mode = "pixiedust";
    };
  };
}
