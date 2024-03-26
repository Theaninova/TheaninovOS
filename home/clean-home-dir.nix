{ config, ... }: {
  xdg.enable = true;
  xdg.userDirs.enable = true;
  home.sessionVariables = {
    HISTFILE = "${config.xdg.stateHome}/bash/history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/config";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_TMP = "${config.xdg.stateHome}/npm";
    WINEPREFIX = "${config.xdg.configHome}/wineprefixes/default";
    _JAVA_OPTGRADLE_USER_HOMEIONS =
      ''-Djava.util.prefs.userRoot="${config.xdg.configHome}"/java'';
    GRADLE_USER_HOME = "${config.xdg.configHome}/gradle";
    DVDCSS_CACHE = "${config.xdg.cacheHome}/dvdcss";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
    PYTHONCACHEPREFIX = "${config.xdg.cacheHome}/python";
    PYTHONUSERBASE = "${config.xdg.dataHome}/python";
    WGETRC = "${config.xdg.configHome}/wgetrc";
    XCOMPOSEFILE = "${config.xdg.configHome}/X11/xcompose";
    XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
  };
  gtk.gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  programs.gpg.homedir = "${config.xdg.configHome}/gnupg";
  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
  programs.zsh.history.path = "${config.xdg.stateHome}/zsh/history";
  xdg.configFile.wgetrc.text = ''
    hsts-file="${config.xdg.cacheHome}/wget-hsts"
  '';
}
