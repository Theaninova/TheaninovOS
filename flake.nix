{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
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
  };

  outputs =
    { nixpkgs, nur, home-manager, ags, nixvim, anyrun, hyprland, ... }@inputs:
    let
      inherit (nixpkgs.lib) genAttrs listToAttrs;
      eachSystem = genAttrs [ "x86_64-linux" ];
      legacyPackages = eachSystem (system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
            experimental-features = "nix-command flakes";
            substituters = [
              "https://hyprland.cachix.org"
              "https://cuda-maintainers.cachix.org"
            ];
            trusted-public-keys = [
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
              "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
            ];
          };
          overlays = [
            nur.overlay
            (final: prev: {
              anyrunPlugins = anyrun.packages.${prev.system};
              hyprland = hyprland.packages.${prev.system}.hyprland;
              xdg-desktop-portal-hyprland =
                hyprland.packages.${prev.system}.xdg-desktop-portal-hyprland;
              ags = ags.packages.${prev.system}.default;
              gbmonctl = prev.callPackage ./overlays/gbmonctl { };
              lpc21isp = prev.callPackage ./overlays/lpc21isp { };
              cura = prev.appimageTools.wrapType2 rec {
                name = "cura";
                version = "5.6.0";
                src = prev.fetchurl {
                  url =
                    "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
                  hash = "sha256-EHiWoNpLKHPzv6rZrtNgEr7y//iVcRYeV/TaCn8QpEA=";
                };
                extraPkgs = pkgs: with pkgs; [ ];
              };
            })
          ];
        });

      mkHost = { hostname, username, desktop, system, stateVersion, }:
        nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages.${system};
          modules = [
            ./modules/nixos/hid-fanatecff
            ./modules/nixos/gbmonctl
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            {
              _module.args = { inherit username; };
              networking.hostName = hostname;
              system.stateVersion = stateVersion;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit username desktop stateVersion inputs;
                };
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
