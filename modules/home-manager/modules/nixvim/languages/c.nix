{
  lib,
  config,
  ...
}:
let
  cfg = config.presets.languages.c;
in
{
  options.presets.languages.c = {
    enable = lib.mkEnableOption "C/C++";
    cppcheck = lib.mkEnableOption "cppcheck";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.settings.formatters_by_ft = {
        c = [ "clang-format" ];
        cpp = [ "clang-format" ];
      };
      none-ls = {
        enable = true;
        sources.diagnostics = {
          cppcheck = lib.mkIf cfg.cppcheck {
            enable = true;
          };
        };
      };
      lsp.servers = {
        cmake.enable = true;
        clangd = {
          enable = true;
          cmd = [
            "clangd"
            "--offset-encoding=utf-16"
            "--clang-tidy"
          ];
          settings.InlayHints = {
            Designators = true;
            Enabled = true;
            ParameterNames = true;
            DeducedTypes = true;
          };
        };
      };
    };
  };
}
