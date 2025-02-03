{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:Theaninova/matugen/add-home-manager-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      matugen,
      nix-flatpak,
      ...
    }@inputs:
    let
      inherit (nixpkgs.lib) genAttrs;
      eachSystem = genAttrs [ "x86_64-linux" ];
      legacyPackages = eachSystem (
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
            experimental-features = "nix-command flakes";
            permittedInsecurePackages = [ "nix-2.25.0pre20240807_cfe66dbe" ];
          };
          overlays = [
            (final: prev: {
              matugen = matugen.packages.${prev.system}.default;
              gccdiag = prev.callPackage ./overlays/gccdiag { };
              gbmonctl = prev.callPackage ./overlays/gbmonctl { };
              lpc21isp = prev.callPackage ./overlays/lpc21isp { };
              rquickshare = prev.callPackage ./overlays/rquickshare { };
              rastertokpsl-re = prev.callPackage ./overlays/rastertokpsl-re { };
              plymouth = prev.plymouth.overrideAttrs (
                final: prev: {
                  patches = prev.patches ++ [ ];
                }
              );
            })
          ];
        }
      );

      mkHost =
        {
          hostname,
          username,
          system,
        }:
        nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages.${system};
          modules = [
            ./modules/nixos
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            nix-flatpak.nixosModules.nix-flatpak
            {
              _module.args = {
                inherit username;
              };
              networking.hostName = hostname;
              services.flatpak.enable = true;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit username inputs;
                };
                users.${username} = {
                  imports = [
                    matugen.homeManagerModules.default
                    nix-flatpak.homeManagerModules.nix-flatpak
                    ./modules/home-manager
                    ./hosts/${hostname}/home.nix
                  ];
                };
              };
            }
          ];
          specialArgs = inputs;
        };
    in
    {
      nixosConfigurations.MONSTER = mkHost {
        hostname = "MONSTER";
        username = "theaninova";
        system = "x86_64-linux";
      };

      nixosModules.theaninovos = import ./modules/nixos;
    };
}
