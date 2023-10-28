{ lib, stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  name = "firefox-gnome-theme";
  version = "116.0.0";
  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "firefox-gnome-theme";
    sparseCheckout = ["scripts"];
    rev = "v116";
    sha256 = "0IS5na2WRSNWNygHhmZOcXhdrx2aFhCDQY8XVVeHf8Q=";
  };
  installPhase = ''
    mkdir -p $out/bin
    cp scripts/install-by-curl.sh $out/bin/install-firefox-gnome-theme
  '';
}
