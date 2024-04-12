{
  config,
  lib,
  pkgs,
  username,
  ...
}:

with lib;

let
  cfg = config.usecases.development;
in
{
  imports = [
    ./development/angular.nix
    ./development/svelte.nix
    ./development/docker.nix
  ];

  options.usecases.development = {
    enable = mkEnableOption "Enable development tools";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gh
      git-filter-repo
      ripgrep
      jq
      httpie
    ];

    home-manager.users.${username} = {
      programs = {
        lazygit.enable = true;
      };
    };
  };
}
