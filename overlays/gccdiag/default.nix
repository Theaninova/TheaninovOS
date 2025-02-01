{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  boost,
  libargs,
  cmake,
}:
let
  cpmCacheDir = ".cpm";
  format = rec {
    repo = "Format.cmake";
    src = fetchFromGitHub {
      owner = "TheLartians";
      inherit repo;
      rev = "v1.7.2";
      hash = "sha256-MFUwJrL0N2wJfj2vkQdKdStPkNJ6AJIYvBhCY6aVpsc=";
    };
    originHash = "23e9a6cadcf1af689dbf4cd8e9a7edf67ddb0009";
    cacheDir = "${lib.toLower repo}/${originHash}";
  };
in
stdenv.mkDerivation rec {
  pname = "gccdiag";
  version = "0.2.6";

  src = fetchFromGitLab {
    owner = "andrejr";
    repo = "gccdiag";
    rev = version;
    hash = "sha256-Oa4JGHCMnTW9uwxUw/+XCfQCElTAD1ifGQJ3ZFl5mys=";
  };

  preConfigure = ''
    export CPM_SOURCE_CACHE=$sourceRoot/${cpmCacheDir}
    mkdir -p "$CPM_SOURCE_CACHE/${format.cacheDir}"
    cp -R --no-preserve=mode,ownership "${format.src}" "$CPM_SOURCE_CACHE/${format.cacheDir}"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libargs
  ];

  cmakeFlags = [
    "-Dgccdiag_USE_CONAN=off"
    "-Dgccdiag_SOURCE_DIST=on"
    "-DGIT_TAG=v${version}"
    "-DSEMVER=${version}"
    "-DVERSION=${version}"
    "-DPROJECT_VERSION=${version}"
    "-DVERSON_MAJOR=${builtins.elemAt (lib.strings.splitString "." version) 0}"
    "-DVERSON_MINOR=${builtins.elemAt (lib.strings.splitString "." version) 1}"
    "-DVERSON_PATCH=${builtins.elemAt (lib.strings.splitString "." version) 2}"
  ];

  meta = with lib; {
    description = "A utility to get gcc (or other compiler) diagnostics for a source file, with appropriate flags extracted from a compilation database";
    homepage = "https://gitlab.com/andrejr/gccdiag";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ theaninova ];
  };
}
