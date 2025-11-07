{ ... }:
{
  programs.git = {
    enable = true;
    signing = {
      key = "6C9E EFC5 1AE0 0131 78DE B9C8 68FF FB1E C187 88CA";
      signByDefault = true;
    };
    settings = {
      user = {
        email = "dev@theaninova.de";
        name = "Thea Schöbl";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
      merge = {
        tool = "nvim-mergetool";
        conflictstyle = "diff3";
      };
      mergetool.nvim-mergetool = {
        cmd = # sh
          ''nvim -f -c "MergetoolStart" "$MERGED" "$BASE" "$LOCAL" "$REMOTE"'';
        trustExitCode = true;
      };
      mergetool.prompt = false;
    };
  };
}
