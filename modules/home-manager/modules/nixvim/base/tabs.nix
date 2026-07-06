{ lib, config, ... }:
let
  cfg = config.presets.base.tabs;
in
{
  options.presets.base.tabs = {
    enable = lib.mkEnableOption "Tabs";
  };

  config = lib.mkIf cfg.enable {
    keymaps = [
      {
        key = "<A-f>";
        action = # vim
          "<cmd>BufferPrevious<CR>";
        options.desc = "Navigate Buffer Left";
      }
      {
        key = "<A-h>";
        action = # vim
          "<cmd>BufferNext<CR>";
        options.desc = "Navigate Buffer Right";
      }
      {
        key = "<A-F>";
        action = # vim
          "<cmd>BufferMovePrevious<CR>";
        options.desc = "Move Buffer Left";
      }
      {
        key = "<A-H>";
        action = # vim
          "<cmd>BufferMoveNext<CR>";
        options.desc = "Move Buffer Right";
      }
      {
        key = "<A-p>";
        action = # vim
          "<cmd>BufferPin<CR>";
        options.desc = "Pin Buffer";
      }
      {
        key = "<A-c>";
        action = # vim
          "<cmd>BufferClose<CR>";
        options.desc = "Close Buffer";
      }
      {
        key = "<A-C>";
        action = # vim
          "<cmd>BufferRestore<CR>";
        options.desc = "Close Buffer";
      }
      {
        key = "gb";
        action = # vim
          "<cmd>BufferPick<CR>";
        options.desc = "Pick Buffer";
      }
    ];
    plugins = {
      barbar = {
        enable = true;
        settings = {
          highlight_inactive_file_icons = true;
          icons = {
            button = "";
            separator = {
              left = "";
              right = "";
            };
            modified.button = "";
            separator_at_end = false;
            pinned = {
              button = "";
              filename = true;
            };
            current = {
              filetype.custom_colors = true;
              separator = {
                left = "";
                right = "";
              };
            };
            inactive = {
              separator = {
                left = "";
                right = "";
              };
            };
          };
          minimum_padding = 1;
          maximum_padding = 1;
          letters = "etarfkcdmhsunobwgiyzqxvplj.,-ETARFKCDMHSUNOBWGIYZQXVPLJ";
        };
      };
      /*
        scope = {
          enable = true;
          settings.hooks = {
            pre_tab_leave.__raw = ''
              function()
                vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabLeavePre'})
              end
            '';
            post_tab_enter.__raw = ''
              function()
                vim.api.nvim_exec_autocmds('User', {pattern = 'ScopeTabEnterPost'})
              end
            '';
          };
        };
      */
    };
  };
}
