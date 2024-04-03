{ pkgs, ... }:
{
  home.packages = [ pkgs.neovide ];
  xdg.configFile."neovide/config.toml".source = ./neovide.toml;
}
