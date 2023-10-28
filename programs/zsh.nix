{ pkgs }:
{
  enable = true;
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "docker" "zsh-interactive-cd" ];
    theme = "amuse";
  };
  plugins = [
    {
      name = "zsh-autosuggestions";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-autosuggestions";
        rev = "v0.7.0";
        sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
      };
    }
    {
      name = "shellfirm";
      src = pkgs.fetchFromGitHub {
        owner = "kaplanelad";
        repo = "shellfirm";
        rev = "v0.2.7";
        sha256 = "sha256-rUK5YoXpjAdxJhoYIf5yNtUGDGnAXCDIkPrgm4QI2jc=";
      };
    }
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "0.7.1";
        sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
      };
    }
  ];
}
