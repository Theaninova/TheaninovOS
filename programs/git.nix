{
  enable = true;
  userName = "Thea Schöbl";
  userEmail = "dev@theaninova.de";
  signing = {
    key = "6C9E EFC5 1AE0 0131 78DE B9C8 68FF FB1E C187 88CA";
    signByDefault = true;
  };
  extraConfig = {
    pull.rebase = true;
    merge = {
      tool = "nvim-mergetool";
      conflictstyle = "diff3";
    };
    mergetool.nvim-mergetool = {
      cmd = ''
        nvim -f -c "MergetoolStart" "$MERGED" "$BASE" "$LOCAL" "$REMOTE"
      '';
      trustExitCode = true;
    };
    mergetool.prompt = false;
  };
}
