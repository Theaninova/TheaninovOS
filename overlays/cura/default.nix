{ lib, appimageTools, fetchurl }:
appimageTools.wrapType2 rec {
  name = "cura";
  version = "5.6.0";
  src = fetchurl {
    url =
      "https://github.com/Ultimaker/Cura/releases/download/${version}/UltiMaker-Cura-${version}-linux-X64.AppImage";
    hash = "sha256-EHiWoNpLKHPzv6rZrtNgEr7y//iVcRYeV/TaCn8QpEA=";
  };
}
