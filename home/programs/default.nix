{pkgs, config, ...}: {
  programs = {
    home-manager.enable = true;
    rbw = import ./bitwarden.nix;
    git = import ./git.nix;
    lazygit.enable = true;
    nixvim = import ./nixvim {inherit pkgs;};
    firefox = import ./firefox.nix {inherit pkgs;};
    gpg.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
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
