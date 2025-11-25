{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "strudel";
  package = "strudel-nvim";
  maintainers = [ lib.maintainers.theaninova ];
  description = "A Neovim based strudel.cc controller, live coding using Strudel from Neovim.";

  settingsOptions = {
    ui = {
      maximise_menu_panel = defaultNullOpts.mkBool true ''
        Maximise the menu panel
      '';
      hide_menu_panel = defaultNullOpts.mkBool false ''
        Hide the Strudel menu panel (and handle)
      '';
      hide_top_bar = defaultNullOpts.mkBool false ''
        Hide the default Strudel top bar (controls)
      '';
      hide_code_editor = defaultNullOpts.mkBool false ''
        Hide the Strudel code editor
      '';
      hide_error_display = defaultNullOpts.mkBool false ''
        Hide the Strudel eval error display under the editor
      '';
    };
    start_on_launch = defaultNullOpts.mkBool true ''
      Automatically start playback when launching Strudel
    '';
    update_on_save = defaultNullOpts.mkBool false ''
      Set to `true` to automatically trigger the code evaluation after saving the buffer content
      Only works if the playback was already started (doesn't start the playback on save)
    '';
    sync_cursor = defaultNullOpts.mkBool true ''
      Enable two-way cursor position sync between Neovim and Strudel editor
    '';
    report_eval_errors = defaultNullOpts.mkBool true ''
      Report evaluation errors from Strudel as Neovim notifications
    '';
    custom_css_file = defaultNullOpts.mkStr null ''
      Path to a custom CSS file to style the Strudel web editor (base64-encoded and injected at launch)
      This allows you to override or extend the default Strudel UI appearance
    '';
    headless = defaultNullOpts.mkBool false ''
      Headless mode: set to `true` to run the browser without launching a window
    '';
    browser_data_dir = defaultNullOpts.mkStr "~/.cache/strudel-nvim/" ''
      Path to the directory where Strudel browser user data (cookies, sessions, etc.) is stored
    '';
    browser_exec_path = defaultNullOpts.mkStr null ''
      Path to a (chromium-based) browser executable of choice
    '';
  };
}
