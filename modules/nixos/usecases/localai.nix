{
  config,
  lib,
  username,
  ...
}:

with lib;

let
  cfg = config.usecases.localai;
in
{
  options.usecases.localai = {
    enable = mkEnableOption "Enable local LLM services";
  };

  config = mkIf cfg.enable {
    services = {
      ollama.enable = true;
      open-webui = {
        enable = true;
        port = 57461;
        environment = {
          ANONYMIZED_TELEMETRY = "False";
          DO_NOT_TRACK = "True";
          SCARF_NO_ANALYTICS = "True";
          WEBUI_AUTH = "False";
        };
      };
    };
    /*
      virtualisation.oci-containers.containers.open-terminal =
      let
        xdg = config.home-manager.users.${username}.xdg;
      in
      {
        podman.user = "${username}";
        image = "ghcr.io/open-webui/open-terminal";
        volumes = [ "${xdg.dataHome}/open-terminal:/home/user" ];
        ports = [ "54183:8000" ];
        extraOptions = [ "--env-file=${xdg.configHome}/open-terminal.env" ];
      };
    */
  };
}
