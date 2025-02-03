{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.shell.components.walker;
  hmConfig = config.home-manager.users.${username};
in
{
  options.shell.components.walker = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable a pre-configured walker setup");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = {
        bindr = [ "SUPER,SUPER_L,exec,uwsm app -- ${lib.getExe pkgs.walker}" ];
        layerrule = [
          # TODO: Add layer rules for walker
          "blur, anyrun"
          "ignorealpha 0.3, anyrun"
        ];
      };
      home.packages = with pkgs; [
        walker
        wl-clipboard
      ];

      xdg.configFile."walker/config.toml".source = (pkgs.formats.toml { }).generate "walker-config.toml" {
        app_launch_prefix = "uwsm app -- ";
        close_when_open = true;
        force_keyboard_focus = true;
      };
      systemd.user.services.walker = {
        Unit = {
          Description = "Walker - Application Runner";
          X-Restart-Triggers = [
            "${hmConfig.xdg.configFile."walker/config.toml".source}"
          ];
          After = [ "graphical-session.target" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${lib.getExe pkgs.walker} --gapplication-service";
          Restart = "always";
        };
      };
    };
  };
}
