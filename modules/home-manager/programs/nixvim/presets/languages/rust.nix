{ lib, config, ... }:
let
  cfg = config.presets.languages.rust;
in
{
  options.presets.languages.rust = {
    enable = lib.mkEnableOption "Rust";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.settings.formattters_by_ft.rust = [ "rustfmt" ];
      lsp.servers.rust-analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
      };
    };
  };
}
