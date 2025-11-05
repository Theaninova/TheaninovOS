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
          "<leader>ff" = {
            action = "git_files";
            mode = "n";
          };
          "<leader>fa" = {
            action = "find_files";
            mode = "n";
          };
          "<leader>fg" = {
            action = "live_grep";
            mode = "n";
          };
          "<leader>fc" = {
            action = "buffers";
            mode = "n";
          };
        };
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
          icon = "󰍉";
        }
        {
          __unkeyed-1 = "<leader>ff";
          desc = "File";
          icon = "󰈢";
        }
        {
          __unkeyed-1 = "<leader>fa";
          desc = "All Files";
          icon = "󱪡";
        }
        {
          __unkeyed-1 = "<leader>fg";
          desc = "Grep";
          icon = "󰑑";
        }
        {
          __unkeyed-1 = "<leader>fc";
          desc = "Current";
          icon = "󰈙";
        }
      ];
    };
  };
}
