{
  config,
  lib,
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
    networking.hosts = {
      "127.0.0.1:57461" = [ "ai.local" ];
    };

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
  };
}
