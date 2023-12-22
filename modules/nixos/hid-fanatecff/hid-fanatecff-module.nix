{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "hid-fanatecff";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff";
    rev = "9c186b51ab7c6da9abef15c73b1d9eababc302a5";
    sha256 = "14rsj4qx8vim0hx8b7a823gqbmzfginq6kpkxjfay0n1693p2895";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  patches = [
    ./hid-fanatec-fix.patch
    ./hid-fanatec-makefile.patch
  ];

  meta = with lib; {
    description = "Linux kernel driver that aims to add support for FANATEC devices";
    homepage = "https://github.com/gotzl/hid-fanatecff";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
