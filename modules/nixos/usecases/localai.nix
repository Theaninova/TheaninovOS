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

  config =
    let
      llama-cpp-turboquant = pkgs.llama-cpp-3-rocm;
      /*
        llama-cpp-turboquant = pkgs.llama-cpp-rocm.overrideAttrs (
          finalAttrs: prevAttrs: {
            version = "tqp-v0.3.0";
            src = pkgs.fetchFromGitHub {
              owner = "TheTom";
              repo = "llama-cpp-turboquant";
              tag = finalAttrs.version;
              hash = "sha256-prdy3m7i+zhSJTzoZNk3RU+GqyExYTSK4uznSJsWLPQ=";
            };
            npmDepsHash = "sha256-TU4Gv+dd48WDpswhfVtm79IVIOwoCXz1fZ/DI/z40Wg=";
          }
        );
      */
    in
    mkIf cfg.enable {
      home-manager.users.${username}.home.packages = [
        llama-cpp-turboquant
        pkgs.opencode
        pkgs.github-copilot-cli
      ];
      services = {
        llama-cpp = {
          enable = true;
          package = llama-cpp-turboquant;
          settings = {
            host = "127.0.0.1";
            port = 9931;
            models-max = 1;
            models-preset = pkgs.writeText "presets.ini" (
              pkgs.lib.generators.toINI { } {
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
                "Qwen3.8-Flash" = {
                  model = "/mnt/llms/Qwen3.8-Flash/Qwen3.8-Flash-Next-UD-IQ3_XXS-00001-of-00003.gguf";
                  threads = 6; # 1 per real core
                  n-gpu-layers = 99;
                  n-cpu-moe = 99;
                  load-mode = "mmap";
                  flash-attn = "on";
                  cache-type-k = "q8_0";
                  cache-type-v = "q8_0";
                  ctx-size = 65536; # 32768;
                  batch-size = 2048;
                  ubatch-size = 512;
                  jinja = true;
                };
              }
            );
          };
          /*
            // (
              let
                model-dir = "/mnt/llms";
                model = ;
              in
              {
                model = "${model-dir}/${model}/${model}-UD-Q4_K_XL.gguf";
                mmproj = "${model-dir}/${model}/mmproj-F16.gguf";
                alias = model;
                threads = 6; # 1 per real core
                ctx-size = 65536; # 262144;
                n-cpu-moe = 35;
                n-gpu-layers = 99;
                no-mmap = true;
                mlock = true;
                jinja = true;
                #flash-attn = "on";
                cache-type-k = "turbo4"; # "q8_0";
                cache-type-v = "turbo3"; # "q8_0";
                temp = 1.0;
                top-p = 0.95;
                top-k = 20;
                #presence-penalty = 1.5;
              }
            );
          */
          /*
            settings = {
              hf-repo = "yuxinlu1/gemma-4-12B-agentic-fable5-composer2.5-v2-3.5x-tau2-GGUF:Q4_K_M";
              #hf-repo = "yuxinlu1/gemma-4-12B-coder-fable5-composer2.5-v1-GGUF:Q4_K_M";
              # offline = true;
              ctx-size = 32768;
              #sleep-idle-seconds = 600;
              n-gpu-layers = 99;
              no-mmap = true;
              flash-attn = "on";
              jinja = true;
              cache-type-k = "q8_0";
              cache-type-v = "q8_0";
              temp = 1.0;
              top-p = 0.95;
              top-k = 64;
              repeat-penalty = 1.1;
            };
          */
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
