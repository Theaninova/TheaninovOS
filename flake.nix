{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen.url = "github:InioX/matugen";
    ags.url = "github:Aylur/ags";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/hyprland";
  };

  outputs =
    {
      nixpkgs,
      nur,
      home-manager,
      ags,
      nixvim,
      anyrun,
      hyprland,
      matugen,
      ...
    }@inputs:
    let
      inherit (nixpkgs.lib) genAttrs listToAttrs;
      eachSystem = genAttrs [ "x86_64-linux" ];
      legacyPackages = eachSystem (
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
            experimental-features = "nix-command flakes";
            substituters = [ "https://hyprland.cachix.org" ];
            trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
          };
          overlays = [
            nur.overlay
            (final: prev: {
              anyrunPlugins = anyrun.packages.${prev.system};
              hyprland = hyprland.packages.${prev.system}.hyprland;
              xdg-desktop-portal-hyprland = hyprland.packages.${prev.system}.xdg-desktop-portal-hyprland;
              ags = ags.packages.${prev.system}.default;
              matugen = matugen.packages.${prev.system}.default;
              gbmonctl = prev.callPackage ./overlays/gbmonctl { };
              lpc21isp = prev.callPackage ./overlays/lpc21isp { };
              darkman = prev.callPackage ./overlays/darkman { };
              cura = prev.callPackage ./overlays/cura { };
              asztal = prev.callPackage ./overlays/asztal { };
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
