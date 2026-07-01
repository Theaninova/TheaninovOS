{
  lib,
  config,
  ...
}:
let
  cfg = config.presets.languages.godot;
in
{
  options.presets.languages.godot = {
    enable = lib.mkEnableOption "Godot";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      godot.enable = true;
      conform-nvim.settings.formatters_by_ft.gdscript = [ "gdscript-formatter" ];
    };
    lsp.servers = {
      gdscript = {
        enable = true;
        package = null;
        config = {
          cmd.__raw = "vim.lsp.rpc.connect('127.0.0.1', tonumber(os.getenv 'GDScript_Port' or '6005'))";
          filetypes = [ "gdscript" ];
          root_markers = [ "project.godot" ];
        };
      };
      gdshader_lsp.enable = true;
    };
  };
}
