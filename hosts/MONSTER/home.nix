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
  services.jellyfin-mpv-shim.enable = true;
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
  programs.git = {
    enable = true;
    signing = {
      format = "openpgp";
      key = "6C9E EFC5 1AE0 0131 78DE B9C8 68FF FB1E C187 88CA";
      signByDefault = true;
    };
    settings = {
      user = {
        email = "dev@theaninova.de";
        name = "Thea Schöbl";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
      merge = {
        tool = "nvim-mergetool";
        conflictstyle = "diff3";
      };
      mergetool.nvim-mergetool = {
        cmd = # sh
          ''nvim -f -c "MergetoolStart" "$MERGED" "$BASE" "$LOCAL" "$REMOTE"'';
        trustExitCode = true;
      };
      mergetool.prompt = false;
    };
  };
}
