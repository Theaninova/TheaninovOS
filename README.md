# TheaninovOS

A NixOS based OS you can configure.

Rebuild the configuration

```sh
home-manager switch --flake ~/.config/home-manager
```

**Make sure new files are added to git**

## Initial Setup on a new machine

Enable flakes

`configuration.nix`

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

```sh
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs

git clone git@github.com:Theaninova/home-manager-config.git ~/.config/home-manager
cd ~/.config/home-manager
sudo nixos-rebuild switch --flake .#MONSTER
```

After that reload the shell

## Updating the system

```sh
# in your config folder
nix flake update
sudo nixos-rebuild switch --flake .#
```

## Cleaning your system

### Cachix is down

By default nix will just crash if cachix is down even if you don't have to fetch anything from it.
Use `--option build-use-substitutes false` to temporarily disable it.

```sh
sudo nixos-rebuild switch --option build-use-substitutes false --flake .#
```

### Find (accidental) folders holding your gc back

```sh
sudo nix-store --gc --print-roots | grep /home
```

### Remove old generations

```sh
sudo nix-collect-garbage -d
```

### Cleanup store

```sh
nix-store --gc
```

## Usage in your NixOS config

`flake.nix`

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    theaninovos = {
      url = "github:Theaninova/TheaninovOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, theaninovos, ... }@inputs:
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
          };
        });

      mkHost = { hostname, username, system }:
        nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages.${system};
          modules = [
            theaninovos.nixosModules.theaninovos
            # ... your stuff
          ];
          specialArgs = inputs;
        };
    in {
      nixosConfigurations.MONSTER = mkHost {
        hostname = "MONSTER";
        username = "theaninova";
        system = "x86_64-linux";
      };
    };
}
```
