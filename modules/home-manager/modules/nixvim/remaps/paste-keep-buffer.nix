{ lib, config, ... }:
let
  cfg = config.presets.remaps.paste-keep-buffer;
in
{
  options.presets.remaps.paste-keep-buffer = {
    enable = lib.mkEnableOption "paste in visual keeps the buffer";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "p";
        mode = "v";
        action = ''"_dP'';
      }
      {
        key = "<leader>p";
        action = ''"_dP'';
      }
    ];
    plugins.which-key = {
      enable = true;
      settings.spec = [
        {
          __unkeyed-1 = "<leader>p";
          desc = "Paste Keep Buffer";
          icon = "";
        }
      ];
    };
  };
}
