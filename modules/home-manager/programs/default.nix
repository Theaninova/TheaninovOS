{ pkgs, ... }:
{
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };
  programs = {
    home-manager.enable = true;
    rbw = {
      enable = true;
      settings = {
        base_url = "pw.theaninova.de";
        email = "pw@theaninova.de";
        pinentry = pkgs.pinentry-gnome3;
      };
    };
    gpg.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
      plugins = with pkgs; [
        {
          name = "zsh-nix-shell";
          file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
          src = zsh-nix-shell;
        }
      ];
      initContent =
        pkgs.lib.mkBefore # sh
          ''
            if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
              source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
            fi
            [[ ! -f ${./.p10k.zsh} ]] || source ${./.p10k.zsh}
            source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
          '';
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
