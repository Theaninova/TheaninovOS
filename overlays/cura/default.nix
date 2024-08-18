{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  name = "cura";
  version = "5.8.0";
  src = fetchurl {
    url = "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
    hash = "sha256-EojVAe+o43W80ES5BY3QgGRTxztwS+B6kIOfJOtULOg=";
  };
}
