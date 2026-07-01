{ lib, config, ... }:
let
  cfg = config.presets.auto-session;
in
{
  options.presets.auto-session = {
    enable = lib.mkEnableOption "auto session";
  };

  config = lib.mkIf cfg.enable {
    opts.sessionoptions = lib.mkDefault (
      lib.strings.concatStringsSep "," [
        "blank"
        "buffers"
        "curdir"
        "folds"
        "help"
        "tabpages"
        "winsize"
        "winpos"
        "terminal"
        "localoptions"
      ]
    );

    plugins = {
      auto-session = {
        enable = lib.mkDefault true;
        settings = {
          cwd_change_handling = lib.mkDefault true;
          lazy_support = false;
          show_auto_restore_notif = true;
          bypass_save_filetypes = [ "neo-tree" ];
        };
      };
      lz-n.enable = true;
      neo-tree.lazyLoad = {
        enable = true;
        settings.cmd = "Neotree";
      };
      fidget.lazyLoad = {
        enable = true;
        settings = {
          event = [ "LspAttach" ];
        };
      };
    };
  };
}
