{
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
  hidapi,
  udev,
}:
buildGoModule rec {
  pname = "gbmonctl";
  version = "1d01a090";
  src = fetchFromGitHub {
    owner = "kelvie";
    repo = "gbmonctl";
    rev = "1d01a9062966e4a3862f4dc51cc5c1f2728d9ea5";
    hash = "sha256-KeBdGtQWz9TBmk1HdXlkIs2r2aZ+EO8WhNaGbsFBBR8=";
  };
  vendorHash = "sha256-cEqpEaX4eJ/6um9qbw/kzg9/vesOWmdiHzZ7IodVV9c=";
  buildInputs = [hidapi udev];
  postInstall = ''
    mkdir -p $out/bin $out/lib/udev/rules.d
    echo 'KERNEL=="hidraw*", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="1100", MODE="0666", TAG+="uaccess"' \
      > $out/lib/udev/rules.d/99-gigabyte-monitor.rules
  '';
  meta = with lib; {
    description = "A CLI tool to change monitor settings over USB to the Gigabyte M32U";
    homepage = "https://github.com/kelvie/gbmonctl";
  };
}
