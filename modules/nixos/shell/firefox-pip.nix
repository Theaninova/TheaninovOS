{
  config,
  lib,
  username,
  ...
}:

let
  cfg = config.shell.components.firefox-pip;
  homeConfig = config.home-manager.users.${username};
in
{
  options.shell.components.firefox-pip = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable firefox-pip");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = {
        windowrulev2 =
          let
            firefoxPip = "class:^(firefox)$,title:^(Picture-in-Picture)$";
            firefoxPipInitial = "class:^(firefox)$,title:^(Firefox)$";
            pipPadding = toString (homeConfig.theme.md3-evo.padding * 2);
          in
          [
            "keepaspectratio,${firefoxPip}"
            "noborder,${firefoxPip}"
            "float,${firefoxPip}"
            "float,${firefoxPipInitial}"
            "pin,${firefoxPip}"
            "pin,${firefoxPipInitial}"
            "fullscreenstate 2 0,${firefoxPip}"
            "fullscreenstate 2 0,${firefoxPipInitial}"
            "move ${pipPadding} ${pipPadding},${firefoxPip}"
            "move ${pipPadding} ${pipPadding},${firefoxPipInitial}"
          ];
      };
    };
  };
}
