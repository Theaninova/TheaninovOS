{ lib, config, ... }:
let
  cfg = config.presets.languages.c;
in
{
  options.presets.languages.c = {
    enable = lib.mkEnableOption "C/C++";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      conform-nvim.settings.formatters_by_ft = {
        c = [ "clang-format" ];
        cpp = [ "clang-format" ];
      };
      lsp.servers.clangd = {
        enable = true;
        cmd = [
          "clangd"
          "--offset-encoding=utf-16"
        ];
      };
    };
  };
}
