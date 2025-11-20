{
  lib,
  pkgs,
  hostname,
  username,
  ...
}:
{
  options.programs.nixvim = lib.mkOption {
    type = pkgs.lib.types.submoduleWith {
      specialArgs = {
        inherit pkgs hostname username;
      };
      modules = [
        ./aerial.nix
        ./auto-save.nix
        ./auto-format.nix
        ./harpoon.nix
        ./mergetool.nix
        ./lazygit.nix
        ./trouble.nix
        ./undotree.nix

        ./base/completion.nix
        ./base/coverage.nix
        ./base/diagnostics.nix
        ./base/find.nix
        ./base/formatting.nix
        ./base/leap.nix
        ./base/spellcheck.nix
        ./base/status-line.nix
        ./base/syntax.nix
        ./base/tree.nix

        ./languages/angular.nix
        ./languages/c.nix
        ./languages/css.nix
        ./languages/cue.nix
        ./languages/dart.nix
        ./languages/js.nix
        ./languages/lua.nix
        ./languages/nix.nix
        ./languages/python.nix
        ./languages/rust.nix
        ./languages/shell.nix
        ./languages/svelte.nix

        ./remaps/half-page-scroll.nix
        ./remaps/no-accidental-macro.nix
        ./remaps/paste-keep-buffer.nix
        ./remaps/wrapped-line-nav.nix
      ];
    };
  };
}
