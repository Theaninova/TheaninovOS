{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      lix-module,
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
          };
          overlays = [
            (final: prev: {
              matugen = matugen.packages.${prev.system}.default;
              gccdiag = prev.callPackage ./overlays/gccdiag { };
              gbmonctl = prev.callPackage ./overlays/gbmonctl { };
              lpc21isp = prev.callPackage ./overlays/lpc21isp { };
              rquickshare = prev.callPackage ./overlays/rquickshare { };
              rastertokpsl-re = prev.callPackage ./overlays/rastertokpsl-re { };
              usb-sniffer = prev.callPackage ./overlays/usb-sniffer { };
              wireshark = prev.wireshark.overrideAttrs (
                finalAttrs: prevAttrs: {
                  postInstall = prevAttrs.postInstall + ''
                    ln -s ${final.usb-sniffer}/bin/usb_sniffer $out/lib/wireshark/extcap/usb_sniffer
                  '';
                }
              );
              plymouth = prev.plymouth.overrideAttrs (
                final: prev: {
                  patches = prev.patches ++ [ ./overlays/plymouth/drm-close-fb.patch ];
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
        nixpkgs.lib.nixosSystem rec {
          pkgs = legacyPackages.${system};
          modules = [
            ./modules/nixos
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            lix-module.nixosModules.default
            nix-flatpak.nixosModules.nix-flatpak
            {
              _module.args =
                let
                  patchDesktop =
                    pkg: appName: from: to:
                    pkgs.lib.hiPrio (
                      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
                        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
                        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
                      ''
                    );
                  GPUOffloadApp = pkg: desktopName: patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ";
                  gpu-offload =
                    config: pkg: desktopName:
                    if config.hardware.nvidia.prime.offload.enable then GPUOffloadApp pkg desktopName else pkg;
                in
                {
                  inherit username hostname gpu-offload;
                };
              nix = {
                nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
                settings = {
                  auto-optimise-store = true;
                  experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                };
                gc = {
                  automatic = true;
                  randomizedDelaySec = "14m";
                  options = "--deleteOlderThan 10d";
                };
              };
              networking.hostName = hostname;
              services.flatpak.enable = true;
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit username hostname inputs;
                };
                sharedModules = [
                  matugen.homeManagerModules.default
                  nix-flatpak.homeManagerModules.nix-flatpak
                  nixvim.homeManagerModules.nixvim
                  ./modules/home-manager/modules/nixvim
                ];
                users.${username} = {
                  nix.gc = {
                    automatic = true;
                    randomizedDelaySec = "14m";
                    options = "--deleteOlderThan 10d";
                  };
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
      nixosConfigurations = {
        MONSTER = mkHost {
          hostname = "MONSTER";
          username = "theaninova";
          system = "x86_64-linux";
        };
        aero = mkHost {
          hostname = "aero";
          username = "theaninova";
          system = "x86_64-linux";
        };
        shark = mkHost {
          hostname = "shark";
          username = "luci";
          system = "x86_64-linux";
        };
      };

      nixosModules.theaninovos = import ./modules/nixos;
    };
}
