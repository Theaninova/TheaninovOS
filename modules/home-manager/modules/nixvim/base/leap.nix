{ lib, config, ... }:
let
  cfg = config.presets.base.leap;
in
{
  options.presets.base.leap = {
    enable = lib.mkEnableOption "leap";
  };

  config = lib.mkIf cfg.enable {
    plugins.leap.enable = true;

    keymaps = [
      {
        key = "s";
        mode = [
          "n"
          "x"
          "o"
        ];
        action.__raw = ''
          function()
            require('leap').leap({
              windows = { vim.api.nvim_get_current_win() },
              inclusive = true
            })
          end
        '';
        options.desc = "Leap";
      }
      {
        key = "R";
        mode = [
          "x"
          "o"
        ];
        action.__raw = ''
          function ()
            require('leap.treesitter').select {
              -- To increase/decrease the selection in a clever-f-like manner,
              -- with the trigger key itself (vRRRRrr...). The default keys
              -- (<enter>/<backspace>) also work, so feel free to skip this.
              opts = require('leap.user').with_traversal_keys('R', 'r')
            }
          end
        '';
      }
    ];

  };
}
