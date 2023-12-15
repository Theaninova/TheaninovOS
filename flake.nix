{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ags,
    nixvim,
    anyrun,
    ...
  }: let
    username = "theaninova";
    system = "x86_64-linux";
    stateVersion = "23.11";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: {anyrunPlugins = anyrun.packages.${prev.system};})
      ];
    };

    homeDirPrefix =
      if pkgs.stdenv.hostPlatform.isDarwin
      then "/Users"
      else "/home";
    homeDirectory = "${homeDirPrefix}/${username}";

    home = import ./home.nix {
      inherit homeDirectory pkgs stateVersion system username;
    };
  in {
    homeConfigurations.theaninova = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ags.homeManagerModules.default
        nixvim.homeManagerModules.nixvim
        anyrun.homeManagerModules.default
        home
      ];
    };
  };
}
