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
          (final: prev: {
            anyrunPlugins = anyrun.packages.${prev.system};
          })
        ];
      });

    mkHost = {
      hostname,
      username,
      desktop,
      system,
      stateVersion,
    }:
      nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages.${system};
        modules = [
          ./modules/nixos/hid-fanatecff
          ./hosts/${hostname}
          home-manager.nixosModules.home-manager
          {
            _module.args = {inherit username;};
            networking.hostName = hostname;
            system.stateVersion = stateVersion;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit username desktop stateVersion inputs;};
              users.${username} = import ./home;
            };
          }
        ];
        specialArgs = inputs;
      };
  in {
    nixosConfigurations.MONSTER = mkHost {
      hostname = "MONSTER";
      username = "theaninova";
      desktop = "hyprland";
      system = "x86_64-linux";
      stateVersion = "23.05";
    };
  };
}
