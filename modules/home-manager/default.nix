{
  username,
  osConfig,
  ...
}:
{
  home = {
    inherit (osConfig.system) stateVersion;
    inherit username;
    homeDirectory = "/home/${username}";
  };
  imports = [
    ./programs/neovide.nix
    ./programs/nixvim.nix
    ./programs/git.nix
    ./packages
    ./programs
    ./services
    ./theme/md3-evo.nix
    ./desktops/hyprland
  ];
}
