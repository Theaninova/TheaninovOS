{ pkgs }:
{
  home-manager.enable = true;
  zsh = import ./programs/zsh.nix { inherit pkgs; };
  rbw = import ./programs/bitwarden.nix;
  git = import ./programs/git.nix;
  nixvim = import ./programs/nixvim.nix { inherit pkgs; };

  nushell = {
    enable = true;
    extraConfig = ''
      let carapace_completer = { |spans|
        carapace $spans.0 nushell $spans | from json
      }

      $env.config = {
        show_banner: false,
        completions: {
          case_sensitive: false
          quick: true
          partial: true
          algorithm: "fuzzy"
          external: {
            enable: true
            max_results: 100
            completer: $carapace_completer
          }
        }
      }

      $env.PATH = ($env.PATH | split row (char esep) | append /usr/bin/env)
      $env.EDITOR = nvim
    '';
  };

  carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
