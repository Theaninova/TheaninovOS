{ pkgs }: with pkgs; [
    cachix
    lorri
    
    # chat apps
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    
    # development
    (import ./packages/intellij.nix { inherit pkgs;
      version = "2023.2.4";
      build = "232.10203.10";
    })
  ];
