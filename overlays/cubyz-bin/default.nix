{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  libx11,
}:
stdenv.mkDerivation rec {
  pname = "cubyz-bin";
  version = "0.0.1";

  src = fetchurl {
    url = "https://github.com/PixelGuys/Cubyz/releases/download/${version}/Linux-x86_64.tar.gz";
    hash = "sha256-Rmh17XpO/CtLDobc8Jb4ojhtM7fUN+ungbVzQlIvE7U=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [ libx11 ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/opt
    cp -R Cubyz $out/opt/Cubyz
    makeWrapper $out/opt/Cubyz/Cubyz $out/bin/cubyz --run "cd $out/opt/Cubyz"
    runHook postInstall
  '';

  preFixup =
    let
      libPath = lib.makeLibraryPath [
        libx11
      ];
    in
    ''
      patchelf \
      --set-rpath "${libPath}" \
      $out/opt/Cubyz/Cubyz
    '';

  meta = with lib; {
    description = "Voxel sandbox game with a large render distance, procedurally generated content and some cool graphical effects.";
    homepage = "https://github.com/PixelGuys/Cubyz";
    maintainers = with maintainers; [ theaninova ];
  };
}
