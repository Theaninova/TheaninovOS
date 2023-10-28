{ pkgs }: pkgs.jetbrains.idea-ultimate.overrideAttrs(prev: {
  version = "2023.2.4";
  src = builtins.fetchurl {
    url = "https://download.jetbrains.com/idea/ideaIU-2023.2.4.tar.gz";
    sha256 = "26fea1a8597e8124dcc24e8ed1dd6f5268e0cd1ba736bbe0e22df3f635ad280b";
  };
})
