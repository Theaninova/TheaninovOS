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
    hyprland.url = "github:hyprwm/hyprland";
    kde2nix.url = "github:nix-community/kde2nix";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ags,
    nixvim,
    anyrun,
    hyprland,
    kde2nix,
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
          substituters = ["https://hyprland.cachix.org"];
          trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        };
        overlays = [
          (final: prev: {
            anyrunPlugins = anyrun.packages.${prev.system};
            hyprland = hyprland.packages.${prev.system}.hyprland;
            xdg-desktop-portal-hyprland = hyprland.packages.${prev.system}.xdg-desktop-portal-hyprland;
            ags = ags.packages.${prev.system}.default;
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
          kde2nix.nixosModules.plasma6
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
