{
  stdenv,
  fetchFromGitHub,
  cmake,
  cups,
  patchPpdFilesHook,
  lib,
}:
stdenv.mkDerivation {
  name = "rastertokpsl-re";
  src = fetchFromGitHub {
    owner = "eLtMosen";
    repo = "rastertokpsl-re";
    rev = "84dcb2bc0d9a6797eedcd56f2e603dde2fbbf290";
    hash = "sha256-qPBZ0qKnY14rTaNa6vjyVB8c0aaXDSewia4n1a6xoyg=";
  };
  buildInputs = [
    cmake
    cups
  ];
  nativeBuildInputs = [ patchPpdFilesHook ];
  installPhase = ''
    runHook preInstall

    install -Dm755 /build/source/bin/rastertokpsl-re $out/lib/cups/filter/rastertokpsl
    mkdir -p $out/share/cups/model/Kyocera
    install -D /build/source/*.ppd $out/share/cups/model/Kyocera

    runHook postInstall
  '';
  ppdFileCommands = [ "rastertokpsl" ];
  meta = with lib; {
    description = "Reverse engineered Kyocera rastertokpsl filter for CUPS";
    homepage = "https://github.com/eLtMosen/rastertokpsl-re";
    license = licenses.asl20;
    maintainers = [ maintainers.theaninova ];
  };
}
