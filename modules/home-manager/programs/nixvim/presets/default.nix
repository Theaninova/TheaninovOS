{ lib, ... }:
{
  options.programs.nixvim = lib.mkOption {
    type = lib.types.submodule (
      { config, ... }:
      {
        imports = [
          ./auto-save.nix
          ./auto-format.nix
          ./harpoon.nix
          ./mergetool.nix
          ./lazygit.nix
          ./trouble.nix
          ./undotree.nix

          ./base/completion.nix
          ./base/diagnostics.nix
          ./base/find.nix
          ./base/formatting.nix
          ./base/status-line.nix
          ./base/syntax.nix
          ./base/tree.nix

          ./languages/angular.nix
          ./languages/c.nix
          ./languages/css.nix
          ./languages/js.nix
          ./languages/lua.nix
          ./languages/nix.nix
          ./languages/python.nix
          ./languages/rust.nix
          ./languages/shell.nix

          ./remaps/half-page-scroll.nix
          ./remaps/no-accidental-macro.nix
          ./remaps/paste-keep-buffer.nix
        ];
      }
    );
  };
}
