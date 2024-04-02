{ pkgs }: {
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
  extraCss = builtins.readFile ./anyrun.css;
}
