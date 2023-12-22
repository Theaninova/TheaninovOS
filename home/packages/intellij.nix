{pkgs}:
pkgs.jetbrains.idea-ultimate.overrideAttrs (prev: {
  version = "233.11799.67";
  src = builtins.fetchurl {
    url = "https://download.jetbrains.com/idea/ideaIU-233.11799.67.tar.gz";
    sha256 = "374153baecd8a633fef3fe75fb5fe47e57f3d136e9873f7bd7ce1166f942559e";
  };
})
