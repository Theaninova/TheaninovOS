{
  username,
  osConfig,
  inputs,
  ...
}:
{
  home = {
    stateVersion = osConfig.system.stateVersion;
    inherit username;
    homeDirectory = "/home/${username}";
  };
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.anyrun.homeManagerModules.default
    ./programs/nixvim/presets
    ./programs/neovide.nix
    ./packages
    ./programs
    ./services
    ./theme/md3-evo.nix
    ./desktops/hyprland
  ];
}
