{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.shell.components.hyprpicker;
in
{
  options.shell.components.hyprpicker = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable a pre-configured hyprpicker");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.wayland.windowManager.hyprland.settings.bind =
      let
        color-picker = pkgs.writeShellScript "color-picker" ''
          ${lib.getExe pkgs.hyprpicker} | ${pkgs.wl-clipboard}/bin/wl-copy
        '';
      in
      [
        {
          _args = [
            "SUPER + SHIFT + C"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('uwsm app -- ${color-picker}')")
          ];
        }
      ];
  };
}
