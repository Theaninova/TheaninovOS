{ pkgs, ... }:
{
  theme.md3-evo = {
    enable = true;
    auto-dark = {
      enable = true;
      lat = 52.52;
      lon = 13.40;
    };
  };
  programs.zoxide.enable = true;
  home.packages = with pkgs; [
    hyperhdr
    /*
      (hyperion-ng.overrideAttrs (
        final: prev: rec {
          version = "2.1.1";
          src = fetchFromGitHub {
            owner = "hyperion-project";
            repo = prev.pname;
            rev = version;
            hash = "sha256-lKLXgOrXp8DLmlpQe/33A30l4K9VX8P0q2LUA+lLYws=";
            # needed for `dependencies/external/`:
            # * rpi_ws281x` - not possible to use as a "system" lib
            # * qmdnsengine - not in nixpkgs yet
            fetchSubmodules = true;
          };
          buildInputs = prev.buildInputs ++ [
            pkgs.libsForQt5.qtwebsockets
            pkgs.libftdi1
          ];
          nativeBuildInputs = prev.nativeBuildInputs ++ [ pkgs.git ];
          cmakeFlags = prev.cmakeFlags ++ [
            "-DUSE_SYSTEM_LIBFTDI_LIBS=ON"
          ];
        }
      ))
    */
  ];
  wayland.windowManager.hyprland.settings.device =
    let
      targetDPI = 1200;
      actualDPI = 3200;
    in
    [
      {
        name = "endgame-gear-endgame-gear-op1-8k-v2-gaming-mouse";
        sensitivity = builtins.toString (((targetDPI + 0.0) / actualDPI) - 1);
        accel_profile = "flat";
      }
    ];
}
