{
  lib,
  config,
  ...
}:
let
  cfg = config.presets.base.coverage;
in
{
  options.presets.base.coverage = {
    enable = lib.mkEnableOption "coverage";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<leader>cs";
        action = # vim
          ":CoverageSummary<CR>";
      }
      {
        key = "<leader>cr";
        action = # vim
          ":CoverageClear<CR>:CoverageLoad<CR>:CoverageShow<CR>";
      }
      {
        key = "<leader>ch";
        action = # vim
          ":CoverageHide<CR>";
      }
      {
        key = "<leader>cc";
        action = # vim
          ":CoverageShow<CR>";
      }
    ];
    autoCmd = [
      {
        event = [ "BufEnter" ];
        callback.__raw = # lua
          ''
            function()
              local ftype = vim.bo.filetype
              local ok, lang = pcall(require, "coverage.languages." .. ftype)
              if not ok then
                return
              end
              local config = require("coverage.config")
              local util = require("coverage.util")
              local Path = require("plenary.path")
              local ft_config = config.opts.lang[ftype]
              if ft_config == nil then
                return
              end
              local p = Path:new(util.get_coverage_file(ft_config.coverage_file))
              if not p:exists() then
                return
              end

              require("coverage").load(true)
            end
          '';
      }
    ];
    plugins = {
      coverage = {
        enable = true;
        autoReload = true;
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>c";
          desc = "Coverage";
          icon = "󰠞";
        }
        {
          __unkeyed-1 = "<leader>cs";
          desc = "Summary";
          icon = "";
        }
        {
          __unkeyed-1 = "<leader>cr";
          desc = "Reload";
          icon = "󰑓";
        }
        {
          __unkeyed-1 = "<leader>ch";
          desc = "Hide";
          icon = "󱨃";
        }
        {
          __unkeyed-1 = "<leader>cc";
          desc = "Show";
          icon = "󱨂";
        }
      ];
    };
  };
}
