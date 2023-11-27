# Home Manager Configuration

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
git clone git@github.com:Theaninova/home-manager-config.git ~/.config/home-manager
nix build '.#homeConfigurations.theaninova.activationPackage'
./result/activate
```

After that reload the shell
