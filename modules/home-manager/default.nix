{
  username,
  osConfig,
  inputs,
  ...
}:
{
  home = {
    inherit (osConfig.system) stateVersion;
    inherit username;
    homeDirectory = "/home/${username}";
  };
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs/nixvim/presets
    ./programs/neovide.nix
    ./packages
    ./programs
    ./services
    ./theme/md3-evo.nix
    ./desktops/hyprland
  ];
}
