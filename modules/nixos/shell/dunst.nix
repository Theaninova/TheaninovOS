{
  config,
  lib,
  username,
  ...
}:

let
  cfg = config.shell.components.dunst;
in
{
  options.shell.components.dunst = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable a pre-configured dunst setup");
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.services.dunst = {
      enable = true;
      settings = { };
    };
  };
}
