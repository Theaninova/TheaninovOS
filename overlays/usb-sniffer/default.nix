{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libusb1,
}:
stdenv.mkDerivation rec {
  pname = "usb_sniffer";
  version = "1d01a090";
  src = fetchFromGitHub {
    owner = "ataradov";
    repo = "usb-sniffer";
    rev = "6eb214825a345c8caeb84bb8f3f2881948348d09";
    hash = "sha256-RpIhNrZXNeUZdh3QHk1KI5Fk8S0MzlYQ4hf4ztnHUII=";
  };
  sourceRoot = "${src.name}/software";
  buildInputs = [
    pkg-config
    libusb1
  ];
  patchPhase = ''
    substituteInPlace Makefile \
      --replace-fail '~/.local/lib/wireshark/extcap' \
      '${placeholder "out"}/bin/${pname}'
  '';
  preInstall = ''
    mkdir -p $out/bin
  '';
  postInstall = ''
    mkdir -p $out/lib/wireshark/extcap
    ln -s ${placeholder "out"}/bin/${pname} $out/lib/wireshark/extcap/usb_sniffer
    mkdir -p $out/lib/udev/rules.d
    cp ${src}/bin/90-usb-sniffer.rules $out/lib/udev/rules.d/90-usb-sniffer.rules
  '';
}
