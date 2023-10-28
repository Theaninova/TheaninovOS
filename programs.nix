{ pkgs }:
{
  home-manager.enable = true;
  zsh = import ./programs/zsh.nix { inherit pkgs; };
  rbw = import ./programs/bitwarden.nix;
  git = import ./programs/git.nix;
}
