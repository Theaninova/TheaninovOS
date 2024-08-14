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
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "git_files";
          "<leader>fa" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
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
          desc = "Untracked Files";
          icon = "󱪡";
        }
        {
          __unkeyed-1 = "<leader>fg";
          desc = "Grep";
          icon = "󰑑";
        }
        {
          __unkeyed-1 = "<leader>fb";
          desc = "Buffer";
          icon = "󰈙";
        }
      ];
    };
  };
}
