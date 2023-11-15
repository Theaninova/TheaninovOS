{ pkgs }: pkgs.jetbrains.idea-ultimate.overrideAttrs(prev: {
  version = "2023.2.5";
  src = builtins.fetchurl {
    url = "https://download.jetbrains.com/idea/ideaIU-2023.2.5.tar.gz";
    sha256 = "1fcffaa924f60d2d74a2494ee3a69e904ae0e91b491ad373639fab61f2568624";
  };
})
