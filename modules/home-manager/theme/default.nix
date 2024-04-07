{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.theme.base16;
in
{
  imports = [ ./integrations/kitty ];

  options.theme.base16 = {
    enable = mkEnableOption "Enable a global base16 theme";
    options = {
      shell = mkOption {
        type = types.string;
        default = "bash -c '{}'";
      };
      items = mkOption {
        type = types.listOf types.attrs;
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ flavours ];

    xdg.configFile."flavours/config.toml".source =
      (pkgs.formats.toml { }).generate "config.toml"
        cfg.options;
  };
}
