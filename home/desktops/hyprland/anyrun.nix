{pkgs}: {
  enable = true;
  config = {
    plugins = with pkgs.anyrunPlugins; [
      applications
      symbols
      rink
      dictionary
      shell
    ];
    y.fraction = 0.2;
    closeOnClick = true;
  };
  extraCss =
    /*
    css
    */
    ''
      * {
        font-family: "NotoSans NF";
      }

      window#window {
        background: transparent;
      }

      box#main {
        background: rgba(48, 52, 70, 0.4);
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.29);
        border-radius: 24px;
      }

      entry#entry {
        border: none;
        box-shadow: none;
        padding: 8px 24px;
      }

      entry#entry,
      list#main {
        border-radius: 24px;
        background: transparent;
      }

      row#match {
        border-radius: 8px;
        padding: 0 4px;
      }

      row#plugin {
        border-radius: 16px;
        padding: 16px;
      }

      list#plugin {
        background: transparent;
      }
    '';
}
