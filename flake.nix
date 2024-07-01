{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen.url = "github:Theaninova/matugen/add-home-manager-module";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nur,
      home-manager,
      nixvim,
      anyrun,
      matugen,
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
          };
          overlays = [
            nur.overlay
            (final: prev: {
              anyrunPlugins = anyrun.packages.${prev.system};
              matugen = matugen.packages.${prev.system}.default;
              gbmonctl = prev.callPackage ./overlays/gbmonctl { };
              lpc21isp = prev.callPackage ./overlays/lpc21isp { };
              rquickshare = prev.callPackage ./overlays/rquickshare { };
              cura = prev.callPackage ./overlays/cura { };
              /*
                kitty = prev.kitty.overrideAttrs (prev: {
                  patches = prev.patches ++ [ ./kitty.patch ];
                });
              */
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
            {
              _module.args = {
                inherit username;
              };
              networking.hostName = hostname;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit username inputs;
                };
                users.${username} = {
                  imports = [
                    matugen.homeManagerModules.default
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
