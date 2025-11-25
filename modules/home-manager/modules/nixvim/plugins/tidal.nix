{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-tidal";
  package = "vim-tidal";
  maintainers = [ lib.maintainers.theaninova ];
  description = "Vim plugin for TidalCycles";
}
