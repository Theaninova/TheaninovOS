{ config, ... }:
{
  theme.md3-evo = {
    enable = true;
    auto-dark = {
      enable = true;
      lat = 52.52;
      lon = 13.40;
    };
  };
  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
    extraConfig.PROJECTS = "${config.home.homeDirectory}/Projects";
  };
  programs.zoxide.enable = true;
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
