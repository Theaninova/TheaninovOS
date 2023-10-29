{
  enable = true;
  settings = {
    main = {
      shell = "fish";
      term = "foot";
      title = "Terminal";
      font = "JetBrainsMono NerdFont:size=12";
      pad = "25x25";
    };
    cursor = {
      style = "beam";
      color = "191c1e e1e2e5";
      beam-thickness = 1.5;
    };
    colors = {
      alpha=0.8;
      background = "191c1e";
      foreground = "e1e2e5";
      regular0 = "191c1e";
      regular1 = "ffb4a9";
      regular2 = "00668b";
      regular3 = "c3e7ff";
      regular4 = "c3e7ff";
      regular5 = "d1e5f4";
      regular6 = "79d0ff";
      regular7 = "c0c7cd";
      bright0 = "191c1e";
      bright1 = "ffb4a9";
      bright2 = "00668b";
      bright3 = "c3e7ff";
      bright4 = "c3e7ff";
      bright5 = "d1e5f4";
      bright6 = "79d0ff";
      bright7 = "c0c7cd";
    };
    key-bindings = {
      scrollback-up-page = "Page_Up";
      scrollback-down-page = "Page_Down";
      clipboard-copy = "Control+c";
      clipboard-paste = "Control+v";
      search-start = "Control+f";
    };
  };
}
