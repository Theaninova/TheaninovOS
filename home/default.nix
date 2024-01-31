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
  xdg.userDirs = {
    enable = true;
    extraConfig = {
      XDG_PROJECTS_DIR = "${home.homeDirectory}/Projects";
    };
  };
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    inputs.anyrun.homeManagerModules.default
    ./programs/neovide.nix
    ./packages
    ./programs
    ./services
    ./desktops/${desktop}
  ];
}
