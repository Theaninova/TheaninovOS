{
  stdenv,
  fetchFromGitHub,
  glibc,
  lib,
}:
stdenv.mkDerivation {
  name = "lpc21isp";
  src = fetchFromGitHub {
    owner = "capiman";
    repo = "lpc21isp";
    rev = "cf89d0b122ef02358e0f130b8f32cb804c11a54e";
    hash = "sha256-BZvtJMtVyqsCPVhp/QL5cXJY8Q25T/RzYzHMutE24hk=";
  };
  nativeBuildInputs = [glibc.static];
  installPhase = ''
    mkdir -p $out/bin
    cp lpc21isp $out/bin
  '';
  meta = with lib; {
    description = "Portable command line ISP for NXP LPC family and Analog Devices ADUC70xx";
    homepage = "https://github.com/capiman/lpc21isp";
    license = licenses.lgpl3Plus;
    maintainers = [maintainers.theaninova];
    mainProgram = "lpc21isp";
  };
}
