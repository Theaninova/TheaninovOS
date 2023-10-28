{ homeDirectory, pkgs, stateVersion, system, username }:
let
  packages = import ./packages.nix { inherit pkgs; };
in {
  imports = [ ./desktops/hyprland/hyprland.nix ];

  home = {
    inherit homeDirectory packages stateVersion username;

    shellAliases = {
      reload-home-manager-config = "home-manager switch --flake ${homeDirectory}/.config/home-manager";
    };
  };

  nixpkgs = {
    config = {
      inherit system;
      allowUnfree = true;
      allowUnsupportedSystem = true;
      experimental-features = "nix-command flakes";
    };
  };

  programs = import ./programs.nix { inherit pkgs; };
  services = import ./services.nix;

  home.file.".p10k.zsh".source = ./programs/.p10k.zsh;
}
