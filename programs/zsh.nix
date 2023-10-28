{ pkgs }:
{
  enable = true;
  zplug = {
    enable = true;
    plugins = [
      { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
      { name = "plugins/docker"; tags = [ from:oh-my-zsh ]; }
      { name = "plugins/zsh-interactive-cd"; tags = [ from:oh-my-zsh ]; }
      { name = "zsh-users/zsh-autosuggestions"; }
      { name = "kaplanelad/shellfirm"; }
      { name = "zsh-users/zsh-syntax-highlighting"; }
      { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
    ];
  };
  initExtra = ''
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  '';
}
