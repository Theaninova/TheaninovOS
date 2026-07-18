{
  config,
  lib,
  pkgs,
  username,
  ...
}:

with lib;

let
  cfg = config.usecases.flatpak;

  home-path = "${config.home-manager.users.${username}.home.path}";
  home-files = "${config.home-manager.users.${username}.home-files}";
  icon_theme_name = "${config.home-manager.users.${username}.gtk.iconTheme.name}";
  theme_name = "${config.home-manager.users.${username}.gtk.theme.name}";
  cursor_theme_name = "${config.home-manager.users.${username}.gtk.cursorTheme.name}";
in
let
  gawk = "${pkgs.gawk}/bin/gawk";
  flatpak = "${pkgs.flatpak}/bin/flatpak";
  su = "${pkgs.su}/bin/su";
  cursor_theme_path = "${home-files}/.local/share/icons/${cursor_theme_name}";
  icon_theme_path = "${home-files}/.local/share/icons/${icon_theme_name}";
  theme_path = "${home-files}/.local/share/themes/${theme_name}";
  icon_theme_path_1 = "${home-path}/share/icons/${icon_theme_name}";
  theme_path_1 = "${home-path}/share/themes/${theme_name}";
in
let
  workaround =
    # sh
    ''
      if [ ! -f /var/lib/flatpak/overrides/global ]; then
        touch /var/lib/flatpak/overrides/global
      fi
      ${gawk} -i inplace '{gsub(/\/nix\/store[^;]*;|!\/nix\/store[^;]*;/,""); print}' /var/lib/flatpak/overrides/global
      ${gawk} -i inplace '{gsub(/filesystems=/,"filesystems=${icon_theme_path};${theme_path};${cursor_theme_path};"); print}' /var/lib/flatpak/overrides/global
      ${gawk} -i inplace '{gsub(/\/nix\/store[^;]*;|!\/nix\/store[^;]*;/,""); print}' "/home/${username}/.local/share/flatpak/overrides/global"
      ${gawk} -i inplace '{gsub(/filesystems=/,"filesystems=${icon_theme_path};${theme_path};${cursor_theme_path};"); print}' "/home/${username}/.local/share/flatpak/overrides/global"
      ${flatpak} override --env=GTK_THEME=${theme_name}
      ${su} "${username}" -c '${flatpak} override --user --env=GTK_THEME=${theme_name}'
    '';
in
{
  options.usecases.flatpak = {
    enable = mkEnableOption "Enable flatpak stuff";
  };

  config = mkIf cfg.enable {
    fonts.fontDir.enable = true;

    # Need to run
    # flatpak --user override --filesystem=$HOME/.local/share/fonts:ro
    # flatpak --user override --filesystem=$HOME/.icons:ro
    # flatpak --user override --filesystem=/nix/store:ro
    # flatpak --user override --filesystem=/run/current-system/sw/share/X11/fonts:ro

    system.fsPackages = [ pkgs.bindfs ];
    fileSystems =
      let
        mkRoSymBind = path: {
          device = path;
          fsType = "fuse.bindfs";
          options = [
            "ro"
            "resolve-symlinks"
            "x-gvfs-hide"
          ];
        };
        fontsPkgs =
          config.fonts.packages
          ++ (with pkgs; [
            # Add your cursor themes and icon packages here
            bibata-cursors
            gnome-themes-extra
            adwaita-icon-theme
            tela-icon-theme
            # etc.
          ]);
        x11Fonts =
          pkgs.runCommand "X11-fonts"
            {
              preferLocalBuild = true;
              nativeBuildInputs = with pkgs; [
                gzip
                mkfontdir
              ];
            }
            (
              ''
                mkdir -p "$out/share/fonts"
                font_regexp='.*\.\(ttf\|ttc\|otb\|otf\|pcf\|pfa\|pfb\|bdf\)\(\.gz\)?'
              ''
              + (builtins.concatStringsSep "\n" (
                builtins.map (pkg: ''
                  find ${toString pkg} -regex "$font_regexp" \
                    -exec ln -sf -t "$out/share/fonts" '{}' \;
                '') fontsPkgs
              ))
              + ''
                cd "$out/share/fonts"
                mkfontscale
                mkfontdir
                cat $(find ${pkgs.font-alias}/ -name fonts.alias) >fonts.alias
              ''
            );
        aggregatedIcons = pkgs.buildEnv {
          name = "system-icons";
          paths = fontsPkgs;
          pathsToLink = [
            "/share/icons"
          ];
        };
      in
      {
        "/usr/share/icons" = mkRoSymBind (aggregatedIcons + "/share/icons");
        "/usr/share/fonts" = mkRoSymBind (x11Fonts + "/share/fonts");
      };

    services.flatpak.enable = true;
    ##workaround for themes and icons
    systemd.services.workaround-for-theme-and-icons = {
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-user-sessions.service" ];
      before = [ "getty.target" ];
      script = workaround;
    };
    home-manager.users.${username}.home.file = {
      ".local/share/icons/${icon_theme_name}".source =
        config.home-manager.users.${username}.lib.file.mkOutOfStoreSymlink
          "${icon_theme_path_1}";
      ".local/share/themes/${theme_name}".source =
        config.home-manager.users.${username}.lib.file.mkOutOfStoreSymlink
          "${theme_path_1}";
    };
  };
}
