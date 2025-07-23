{
  config,
  lib,
  pkgs,
  username,
  ...
}:

let
  cfg = config.shell.components.grimblast;
in
{
  options.shell.components.grimblast = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable pre-configured grimblast");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland = {
        settings = {
          bind = [
            "SUPER_SHIFT,V,exec,uwsm app -- ${lib.getExe pkgs.grimblast} --freeze copy area"
          ];
        };
      };
      home = {
        # bugged, freezes
        sessionVariables.GRIMBLAST_EDITOR = "${lib.getExe pkgs.annotator}";
        packages = with pkgs; [
          grimblast
          annotator
        ];
      };
    };
  };
}
