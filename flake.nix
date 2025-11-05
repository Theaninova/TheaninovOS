{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.3-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:InioX/matugen?ref=v2.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      lix-module,
      matugen,
      nix-flatpak,
      niri,
      dank-material-shell,
      ...
    }@inputs:
    let
      inherit (nixpkgs.lib) genAttrs;
      eachSystem = genAttrs [ "x86_64-linux" ];
      legacyPackages =
        config:
        (eachSystem (
          system:
          import nixpkgs {
            inherit system;
            config = config // {
              allowUnfree = true;
              allowUnsupportedSystem = true;
              experimental-features = "nix-command flakes";
            };
            overlays = [
              niri.overlays.niri
              (final: prev: {
                matugen = matugen.packages.${prev.system}.default;
                gccdiag = prev.callPackage ./overlays/gccdiag { };
                gbmonctl = prev.callPackage ./overlays/gbmonctl { };
                lpc21isp = prev.callPackage ./overlays/lpc21isp { };
                rquickshare = prev.callPackage ./overlays/rquickshare { };
                rastertokpsl-re = prev.callPackage ./overlays/rastertokpsl-re { };
                usb-sniffer = prev.callPackage ./overlays/usb-sniffer { };
                gamma-launcher = prev.callPackage ./overlays/gamma-launcher { };
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
        ));

      mkHost =
        {
          hostname,
          username,
          system,
          config ? { },
        }:
        nixpkgs.lib.nixosSystem rec {
          pkgs = (legacyPackages config).${system};
          modules = [
            ./modules/nixos
            ./hosts/${hostname}
            home-manager.nixosModules.home-manager
            dank-material-shell.nixosModules.greeter
            niri.nixosModules.niri
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
                  ./overlays/matugen/hm-module.nix
                  nix-flatpak.homeManagerModules.nix-flatpak
                  nixvim.homeModules.nixvim
                  dank-material-shell.homeModules.dankMaterialShell.default
                  dank-material-shell.homeModules.dankMaterialShell.niri
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
          config = {
            rocmSupport = true;
          };
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
