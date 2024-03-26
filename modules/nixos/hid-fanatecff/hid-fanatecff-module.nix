{ lib, stdenv, kernel, fetchFromGitHub, }:
stdenv.mkDerivation rec {
  pname = "hid-fanatecff";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff";
    rev = "ce894fb7bcae486978f8165e9f521e480120f98a";
    hash = "sha256-/106K52Zi4/6aWh2EwojRm370poaBHyX3Ke2j52ytdo=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=${src}"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description =
      "Linux kernel driver that aims to add support for FANATEC devices";
    homepage = "https://github.com/gotzl/hid-fanatecff";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
