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
      which-key.registrations."<leader>f" = {
        name = "Find";
        f = "File";
        a = "Untracked Files";
        g = "Grep";
        b = "Buffer";
      };
    };
  };
}
