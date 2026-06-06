{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.shell.components.walker;
in
{
  options.shell.components.walker = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable a pre-configured walker setup");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings = {
        bind = [
          {
            _args = [
              "SUPER + SUPER_L"
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd('uwsm app -- ${lib.getExe pkgs.walker}')")
              { release = true; }
            ];
          }
        ];
        /*
          layerrule = [
            # TODO: Add layer rules for walker
            "blur, anyrun"
            "ignorealpha 0.3, anyrun"
          ];
        */
      };
      programs.niri.settings.binds."Mod+Space".action.spawn = [ (lib.getExe pkgs.walker) ];
      home.packages = with pkgs; [
        wl-clipboard
      ];
      programs.walker = {
        enable = true;
        runAsService = true;
        config = {
          close_when_open = true;
          force_keyboard_focus = true;
        };
      };
    };
  };
}
