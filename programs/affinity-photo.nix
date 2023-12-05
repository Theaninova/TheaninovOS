{
  stdenv,
  fetchurl,
  pkgs,
  p7zip,
  wineWowPackages,
  winetricks,
}:
stdenv.mkDerivation rec {
  name = "affinity-photo";
  version = "1.10.6";

  src = ./affinity-photo-${version}.exe;
  dontUnpack = true;

  buildInputs = [wineWowPackages.stable winetricks];

  installPhase = ''
    mkdir -p $out/share/$name
    cd $out/share/$name
    ${p7zip}/bin/7z x $src

    mkdir -p $out/bin
    cd $out/bin
    echo "#!${stdenv.shell}" >> $name
    echo "export WINEARCH=win64" >> $name
    echo "export WINEPREFIX=~/.config/$name" >> $name
    echo "${winetricks}/bin/winetricks -q corefonts dotnet472" >> $name
    echo "${wineWowPackages.stable}/bin/wine $out/share/$name/App.exe" >> $name
    chmod +x $name
  '';
}
