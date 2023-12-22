{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
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
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs listToAttrs;
    eachSystem = genAttrs ["x86_64-linux"];
    legacyPackages = eachSystem (system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
          experimental-features = "nix-command flakes";
        };
        overlays = [
          (final: prev: {anyrunPlugins = anyrun.packages.${prev.system};})
        ];
      });

    mkHome = {
      username,
      desktop,
      system,
    }:
      home-manager.lib.homeManagerConfiguration rec {
        homeDirectory = "/home/${username}";
        modules = [
          ags.homeManagerModules.default
          nixvim.homeManagerModules.nixvim
          anyrun.homeManagerModules.default
          ./home/packages
          ./home/programs
          ./home/services
          ./home/desktops/${desktop}
        ];
        pkgs = legacyPackages.${system};
      };

    mkHost = {
      hostname,
      system,
      stateVersion,
    }:
      nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages.${system};
        modules = [
          ./modules/nixos/hid-fanatecff
          ./hosts/${hostname}
          {
            networking.hostName = hostname;
            system.stateVersion = stateVersion;
          }
        ];
        specialArgs = inputs;
      };
  in {
    homeConfigurations.theaninova = mkHome {
      username = "theaninova";
      desktop = "hyprland";
    };

    nixosConfigurations.MONSTER = mkHost {
      hostname = "MONSTER";
      system = "x86_64-linux";
      stateVersion = "23.05";
    };
  };
}
