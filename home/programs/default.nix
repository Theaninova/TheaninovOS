{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    rbw = import ./bitwarden.nix;
    git = import ./git.nix;
    lazygit.enable = true;
    nixvim = import ./nixvim.nix {inherit pkgs;};
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
  };
}
