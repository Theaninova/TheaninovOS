{
  enable = true;
  settings = {
    main = {
      font = "Lexend";
      terminal = "foot -e";
      prompt = ">>  ";
      layer = "overlay";
    };
    colors = {
      background = "191c1ecc";
      text = "e1e2e5ff";
      selection = "41484dff";
      selection-text = "c0c7cdff";
      border = "41484dff";
      match = "79d0ffff";
      selection-match = "79d0ffff";
    };
    border = {
      radius = 17;
      width = 2;
    };
    dmenu.exit-immediately-if-empty = "yes";
  };
}
