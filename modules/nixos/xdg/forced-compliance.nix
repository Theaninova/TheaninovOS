{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.xdg.forced-compliance;
  itgr = cfg.integrations;
  homeConfig = config.home-manager.users.${username};
  xdgConfig = homeConfig.xdg;
  mkIntegrationOption =
    name:
    lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable ${name} integration.";
      type = lib.types.bool;
    };
in
{
  options.xdg.forced-compliance = {
    enable = lib.mkEnableOption ''
      a best-effort attempt to get everything to comply with the xdg spec.
      Has a chance of breaking some programs with hard-coded paths
    '';
    integrations = {
      android = mkIntegrationOption "android";
      bash = mkIntegrationOption "bash";
      cargo = mkIntegrationOption "cargo";
      cuda = mkIntegrationOption "cuda";
      docker = mkIntegrationOption "docker";
      dvdcss = mkIntegrationOption "dvdcss";
      gpg = mkIntegrationOption "gpg";
      gradle = mkIntegrationOption "gradle";
      gtk2 = mkIntegrationOption "gtk2";
      ionic-cli = mkIntegrationOption "ionic-cli";
      java = mkIntegrationOption "java"; # some apps just won't respect this
      # TODO: `.mozilla` (unsupported)
      nix = mkIntegrationOption "nix";
      npm = mkIntegrationOption "npm";
      # TODO: `.icons`
      # https://github.com/nix-community/home-manager/blob/bfa7c06436771e3a0c666ccc6ee01e815d4c33aa/modules/config/home-cursor.nix#L153
      # deliberately blocked by home manager :(
      # TODO: `.pki`
      # Technically this is supporte out of the box, but some programs just
      # create it out of nowhere https://bugzilla.mozilla.org/show_bug.cgi?id=818686#c11
      python = mkIntegrationOption "python";
      # TODO: `.ssh` (unsupported)
      # TODO: `steam` (unsupported)
      wget = mkIntegrationOption "wget";
      wine = mkIntegrationOption "wine";
      xcompose = mkIntegrationOption "xcompose";
      zsh = mkIntegrationOption "zsh";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.extraOptions = ''
      use-xdg-base-directories = true
    '';

    environment.etc."zshenv".text = lib.mkIf itgr.zsh ''
      source ${xdgConfig.configHome}/zsh/.zshenv
    '';

    home-manager.users.${username} = {
      xdg = {
        enable = true;
        userDirs.enable = true;
        configFile.wgetrc.text = lib.mkIf itgr.wget ''
          hsts-file="${xdgConfig.cacheHome}/wget-hsts"
        '';
      };

      home.sessionVariables = {
        _JAVA_OPTGRADLE_USER_HOMEIONS = lib.mkIf itgr.java ''-Djava.util.prefs.userRoot="${xdgConfig.configHome}"/java'';
        ANDROID_USER_HOME = lib.mkIf itgr.android "${xdgConfig.dataHome}/android";
        CARGO_HOME = lib.mkIf itgr.cargo "${xdgConfig.dataHome}/cargo";
        CUDA_CACHE_PATH = lib.mkIf itgr.cuda "${xdgConfig.cacheHome}/cuda";
        DOCKER_CONFIG = lib.mkIf itgr.docker "${xdgConfig.configHome}/docker";
        DVDCSS_CACHE = lib.mkIf itgr.dvdcss "${xdgConfig.cacheHome}/dvdcss";
        GRADLE_USER_HOME = lib.mkIf itgr.gradle "${xdgConfig.configHome}/gradle";
        NPM_CONFIG_CACHE = lib.mkIf itgr.npm "${xdgConfig.cacheHome}/npm";
        NPM_CONFIG_TMP = lib.mkIf itgr.npm "${xdgConfig.stateHome}/npm";
        NPM_CONFIG_USERCONFIG = lib.mkIf itgr.npm "${xdgConfig.configHome}/npm/config";
        PYTHON_HISTORY = lib.mkIf itgr.python "${xdgConfig.stateHome}/python/history";
        PYTHONCACHEPREFIX = lib.mkIf itgr.python "${xdgConfig.cacheHome}/python";
        PYTHONUSERBASE = lib.mkIf itgr.python "${xdgConfig.dataHome}/python";
        WGETRC = lib.mkIf itgr.wget "${xdgConfig.configHome}/wgetrc";
        WINEPREFIX = lib.mkIf itgr.wine "${xdgConfig.dataHome}/wine";
        XCOMPOSECACHE = lib.mkIf itgr.xcompose "${xdgConfig.cacheHome}/X11/xcompose";
        XCOMPOSEFILE = lib.mkIf itgr.xcompose "${xdgConfig.configHome}/X11/xcompose";
      };
      home.file.".zshenv".enable = false;
      gtk.gtk2.configLocation = lib.mkIf itgr.gtk2 "${xdgConfig.configHome}/gtk-2.0/gtkrc";
      programs = {
        gpg.homedir = lib.mkIf itgr.gpg "${xdgConfig.configHome}/gnupg";
        bash.historyFile = lib.mkIf itgr.bash "${xdgConfig.stateHome}/bash/history";
        zsh = lib.mkIf itgr.zsh {
          dotDir = ".config/zsh";
          history.path = "${xdgConfig.stateHome}/zsh/history";
        };
      };
    };
  };
}
