{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    rbw = import ./bitwarden.nix;
    git = import ./git.nix;
    lazygit.enable = true;
    nixvim = import ./nixvim.nix {inherit pkgs;};
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    fish = {
      enable = true;
      shellInit = ''
        fish_vi_key_bindings
      '';
      interactiveShellInit = ''
        set fish_greeting
      '';
    };
    oh-my-posh = {
      enable = true;
      useTheme = "pararussel";
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
