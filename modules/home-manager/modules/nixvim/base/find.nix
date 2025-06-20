{ lib, config, ... }:
let
  cfg = config.presets.base.find;
in
{
  options.presets.base.find = {
    enable = lib.mkEnableOption "file finding";
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      web-devicons.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "ff" = {
            action = "git_files";
            mode = "n";
          };
          "fa" = {
            action = "find_files";
            mode = "n";
          };
          "fg" = {
            action = "live_grep";
            mode = "n";
          };
          "fc" = {
            action = "buffers";
            mode = "n";
          };
        };
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "f";
          group = "Find";
          icon = "󰍉";
        }
        {
          __unkeyed-1 = "ff";
          desc = "File";
          icon = "󰈢";
        }
        {
          __unkeyed-1 = "fa";
          desc = "All Files";
          icon = "󱪡";
        }
        {
          __unkeyed-1 = "fg";
          desc = "Grep";
          icon = "󰑑";
        }
        {
          __unkeyed-1 = "fc";
          desc = "Current";
          icon = "󰈙";
        }
      ];
    };
  };
}
