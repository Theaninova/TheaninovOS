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
      };
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
