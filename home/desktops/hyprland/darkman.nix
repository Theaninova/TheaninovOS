{
  pkgs,
  config,
  ...
}: {
  services.darkman = let
    wallpaperPath = "${config.home.homeDirectory}/.local/state/wallpaper.jpg";
  in {
    enable = true;
    package = pkgs.buildGoModule rec {
      pname = "darkman";
      version = "1.5.4";

      src = pkgs.fetchFromGitLab {
        owner = "WhyNotHugo";
        repo = "darkman";
        rev = "5332193777fb0c5dbde6cbfd015a16697d6a0c8e";
        hash = "sha256-3TGDy7hiI+z0IrA+d/Q+rMFlew6gipdpXyJ5eVLCmds=";
      };

      vendorHash = "sha256-xEPmNnaDwFU4l2G4cMvtNeQ9KneF5g9ViQSFrDkrafY=";

      nativeBuildInputs = [pkgs.scdoc];

      postPatch = ''
        substituteInPlace darkman.service \
          --replace "/usr/bin/darkman" "$out/bin/darkman"
        substituteInPlace contrib/dbus/nl.whynothugo.darkman.service \
          --replace "/usr/bin/darkman" "$out/bin/darkman"
        substituteInPlace contrib/dbus/org.freedesktop.impl.portal.desktop.darkman.service \
          --replace "/usr/bin/darkman" "$out/bin/darkman"
      '';

      buildPhase = ''
        runHook preBuild
        make build
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        make PREFIX=$out install
        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "Framework for dark-mode and light-mode transitions on Linux desktop";
        homepage = "https://gitlab.com/WhyNotHugo/darkman";
        license = licenses.isc;
        maintainers = [maintainers.ajgrf];
        platforms = platforms.linux;
        mainProgram = "darkman";
      };
    };
    settings = {
      lat = 52.52;
      lng = 13.405;
    };
    darkModeScripts = {
      gtk-theme =
        /*
        bash
        */
        ''
          ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        '';
      kitty-theme =
        /*
        bash
        */
        ''
          ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all --config-file-name ${config.home.homeDirectory}/.config/kitty/current-colors.conf Catppuccin-Frappe
        '';
      wallpaper =
        /*
        bash
        */
        ''
          ${pkgs.coreutils}/bin/ln -sf ${./wallpapers/Lakeside-2/Lakeside-2-1.jpg} ${wallpaperPath}
          ${pkgs.swww}/bin/swww img ${wallpaperPath}
        '';
    };
    lightModeScripts = {
      gtk-theme =
        /*
        bash
        */
        ''
          ${pkgs.dconf}/bin/dconf write \
            /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        '';
      kitty-theme =
        /*
        bash
        */
        ''
          ${pkgs.kitty}/bin/kitty +kitten themes --reload-in=all --config-file-name ${config.home.homeDirectory}/.config/kitty/current-colors.conf Catppuccin-Latte
        '';
      wallpaper =
        /*
        bash
        */
        ''
          ${pkgs.coreutils}/bin/ln -sf ${./wallpapers/Lakeside-2/Lakeside-2-10.jpg} ${wallpaperPath}
          ${pkgs.swww}/bin/swww img ${wallpaperPath}
        '';
    };
  };
}
