{
  vimUtils,
  fetchFromGitHub,
  lib,
}:
vimUtils.buildVimPlugin {
  name = "strudel-nvim";
  src = fetchFromGitHub {
    owner = "gruvw";
    repo = "strudel.nvim";
    rev = "97699f9f08b0deb635038687f92c6237ab67e3b5";
    hash = "sha256-xe7ItXCfq+gqXxm2Y6zxbiz4AAGgPaP/w6zNgpL+Cl4=";
  };
}
