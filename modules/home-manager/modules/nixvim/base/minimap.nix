{ lib, config, ... }:
let
  cfg = config.presets.base.minimap;
in
{
  options.presets.base.minimap = {
    enable = lib.mkEnableOption "minimap";
  };

  config = lib.mkIf cfg.enable {
    globals = {
      minimap_width = 10;
      minimap_auto_start = 1;
      minimap_auto_start_win_enter = 1;
      minimap_close_buftypes = [ "nofile" ];
      minimap_block_filetypes = [ "NvimTree" ];
    };
  };
}
