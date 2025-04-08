{
  lib,
  config,
  ...
}:
let
  cfg = config.presets.aerial;
in
{
  options.presets.aerial = {
    enable = lib.mkEnableOption "aerial";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<C-Up>";
        action = # vim
          ":AerialPrev<CR>";
      }
      {
        key = "<C-Down>";
        action = # vim
          ":AerialNext<CR>";
      }
      {
        key = "fs";
        mode = "n";
        action = # vim
          ":Telescope aerial<CR>";
      }
    ];
    plugins = {
      aerial = {
        enable = true;
        settings = {
          autojump = true;
          highlight_on_jump = false;
          filter_kind = false;
          open_automatic = true;
          show_guides = true;
          backends = [
            "lsp"
            "treesitter"
            "markdown"
            "asciidoc"
            "man"
          ];
          layout = {
            placement = "edge";
            direction = "right";
          };
        };
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "fs";
          group = "Symbols";
          icon = "󰡱";
        }
      ];
    };
  };
}
