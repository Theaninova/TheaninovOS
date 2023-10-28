{ pkgs, version, build }: pkgs.jetbrains.idea-ultimate.overrideAttrs(prev: {
  version = "${version}";
  build_number = "${build}";
  src = builtins.fetchurl {
    url = "https://download.jetbrains.com/idea/ideaIU-${version}.tar.gz";
  };
});
