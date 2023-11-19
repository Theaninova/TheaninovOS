{ pkgs }: pkgs.jetbrains.idea-ultimate.overrideAttrs(prev: {
  version = "233.11799.30";
  src = builtins.fetchurl {
    url = "https://download.jetbrains.com/idea/ideaIU-233.11799.30.tar.gz";
    sha256 = "c5db01f201660c9bd3427383f6ae9179293cbdeae7e54e2d708b4d70248d8427";
  };
})
