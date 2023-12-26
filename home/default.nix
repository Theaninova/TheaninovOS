{
  username,
  desktop,
  stateVersion,
  osConfig,
  inputs,
  ...
}: {
  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
    shellAliases = {
      nix-reload-home = "home-manager switch --flake ${./..}";
      nix-reload-system = "nixos-rebuild switch --flake ${./..}";
    };
  };
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    inputs.anyrun.homeManagerModules.default
    ./packages
    ./programs
    ./services
    ./desktops/${desktop}
  ];
}
