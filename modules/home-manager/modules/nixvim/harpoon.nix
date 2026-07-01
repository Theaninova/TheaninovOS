{ lib, config, ... }:
let
  cfg = config.presets.harpoon;
in
{
  options.presets.harpoon = {
    enable = lib.mkEnableOption "Harpoon";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<leader>m";
        mode = "n";
        action.__raw = ''
          function() require("harpoon"):list():add() end
        '';
        options.desc = "Mark";
      }
      {
        key = "<leader><leader>";
        mode = "n";
        action.__raw = ''
          function()
            local harpoon = require("harpoon")
            local conf = require("telescope.config").values

            local harpoon_files = harpoon:list()

            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
              table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
              prompt_title = "Harpoon",
              finder = require("telescope.finders").new_table({
                results = file_paths,
              }),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
            }):find()
          end
        '';
        options.desc = "Harpoon List";
      }
      {
        key = "<C-n>";
        mode = "n";
        action.__raw = ''
          function() require("harpoon"):list():next() end
        '';
        options.desc = "Harpoon Next";
      }
      {
        key = "<C-p>";
        mode = "n";
        action.__raw = ''
          function() require("harpoon"):list():prev() end
        '';
        options.desc = "Harpoon Prev";
      }
    ];
    plugins.harpoon = {
      enable = true;
      enableTelescope = true;
    };
  };
}
