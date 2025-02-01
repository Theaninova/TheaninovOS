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
      lsp.servers.rust_analyzer = {
        enable = true;
        installCargo = false;
        installRustc = false;
        settings.inlayHints = {
          bindingModeHints.enable = false;
          chainingHints.enable = true;
          closingBraceHints = {
            enable = true;
            minLines = 25;
          };
          closureReturnTypeHints.enable = "never";
          lifetimeElisionHints = {
            enable = "never";
            useParameterNames = false;
          };
          maxLength = 25;
          parameterHints.enable = true;
          reborrowHints.enable = "never";
          renderColons = true;
          typeHints = {
            enable = true;
            hideClosureInitialization = false;
            hideNamedConstructor = false;
          };
        };
      };
    };
  };
}
