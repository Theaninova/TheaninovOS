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
cd ~/.config/home-manager
sudo nixos-rebuild switch --flake .#
```

After that reload the shell

## Updating the system

```sh
# in your config folder
nix flake update
sudo nixos-rebuild switch --flake .#
```

## Adapting the config

Few not so obvious things you might wanna adjust (non-exhaustive):

- The default layout is configured for my [CharaChorder 1](https://www.charachorder.com/en-de/products/charachorder-one).
  You probably don't want that, though most you won't notice.
- **Subpixel rendering is set up for a BGR layout.** Most likely you'll have an RGB layout.
- Hyprland is configured with a layout that works on a 43" screen. You'll probably want to adjust that.a
- Keybinds in Hyprland are made to work on my [CharaChorder 1](https://www.charachorder.com/en-de/products/charachorder-one).
  They'll be horrible to use on a qwerty keyboard.
