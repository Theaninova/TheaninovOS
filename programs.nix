{ pkgs }:
{
  home-manager.enable = true;
  rbw = import ./programs/bitwarden.nix;
  git = import ./programs/git.nix;
  lazygit.enable = true;
  nixvim = import ./programs/nixvim.nix { inherit pkgs; };
  fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
  oh-my-posh = {
    enable = true;
    useTheme = "pararussel";
    enableFishIntegration = true;
  };
}
