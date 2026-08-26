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
        window_rule = [
          {
            name = "firefox-pip";
            match = {
              class = "^(firefox)$";
              title = "^(Picture-in-Picture)$";
            };
            float = true;
            no_follow_mouse = true;
            opaque = true;
            pin = true;
            fullscreen_state = "2 0";
            move = "240 8";
            keep_aspect_ratio = true;
            border_size = 0;
            animation = "fade";
          }
        ];
      };
    };
  };
}
