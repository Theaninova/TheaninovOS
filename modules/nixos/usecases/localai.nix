{
  config,
  lib,
  pkgs,
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
    home-manager.users.${username}.home.packages = [
      pkgs.llama-cpp-codacus
      pkgs.opencode
      pkgs.github-copilot-cli
    ];
    services = {
      llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-codacus;
        settings = {
          host = "127.0.0.1";
          port = 9931;
          models-max = 1;
          models-preset = pkgs.writeText "presets.ini" (
            pkgs.lib.generators.toINI { } {
              /*
                "Qwen3.6-35B-A3B" = {
                  #model = "/mnt/llms/Qwen3.6-35B-A3B/Qwen3.6-35B-A3B-UD-Q6_K.gguf";
                  model = "/mnt/llms/Qwen3.6-35B-A3B/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf";
                  threads = 6; # 1 per real core
                  ctx-size = 131072; # 262144;
                  n-cpu-moe = 34;
                  n-gpu-layers = 999;
                  load-mode = "mlock";
                  #no-mmap = true;
                  #mlock = true;
                  jinja = true;
                  cache-type-k = "q8_0";
                  cache-type-v = "q8_0";
                  #cache-type-k = "turbo4";
                  #cache-type-v = "turbo3";
                  #temp = 1.0;
                  #top-p = 0.95;
                  #top-k = 20;
                };
              */
              "Qwen3.8-Flash" = {
                model = "/mnt/llms/Qwen3.8-Flash/Qwen3.8-Flash-Next-UD-IQ3_XXS-00001-of-00003.gguf";
                threads = 6; # 1 per real core
                # threads-batch = 16;
                parallel = 1;
                n-gpu-layers = 99;
                n-cpu-moe = 99;
                load-mode = "mmap";
                flash-attn = "on";

                moe-cache-slots = 48;
                spec-type = "draft-mtp";
                spec-draft-model = "/mnt/llms/Qwen3.8-Flash/mtp-Qwen3.8-Flash-Next-shared-Q8_0.gguf";
                spec-draft-n-max = 1;
                spec-draft-ngl = 0;
                cache-reuse = 256;
                fit = "off";
                no-sched-async-cpu = true;

                cache-type-k = "q8_0";
                cache-type-v = "q8_0";
                ctx-size = 131072; # 32768;
                batch-size = 2048;
                ubatch-size = 512;
                jinja = true;
              };
            }
          );
        };
      };
      /*
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
      */
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
