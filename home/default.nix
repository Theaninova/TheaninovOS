{
  username,
  desktop,
  stateVersion,
  osConfig,
  inputs,
  ...
}: rec {
  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
  };
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    inputs.anyrun.homeManagerModules.default
    ./clean-home-dir.nix
    ./programs/neovide.nix
    ./packages
    ./programs
    ./services
    ./desktops/${desktop}
  ];
}
