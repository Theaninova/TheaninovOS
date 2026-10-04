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

  models-preset = pkgs.writeText "presets.ini" (
    pkgs.lib.generators.toINI { } {
      "Qwen3.8-Flash" = {
        # model = "/mnt/llms/Qwen3.8-Flash/Qwen3.8-Flash-Next-GSQ-RCO-IQ3_XXS-00001-of-00002.gguf";
        model = "/mnt/llms/Qwen3.8-Flash/Qwen3.8-Flash-Next-GSQ-RCO-IQ3_S-00001-of-00002.gguf";
        cpu-range = "0-5";
        cpu-strict = 1;
        threads = 6;
        threads-batch = 12;
        cpu-range-batch = "0-11";
        parallel = 1;
        cpu-moe = true;
        load-mode = "mmap";
        lazy-mode = "on";
        flash-attn = "on";

        mmproj = "/mnt/llms/Qwen3.8-Flash/mmproj-Qwen3.8-Flash-Next-BF16.gguf";
        no-mmproj-offload = true;

        # moe-cache-profile = "/mnt/llms/Qwen3.8-Flash/trace/qwen-merged.csv";
        # moe-cache-slots = 48;

        /*
          spec-type = "draft-mtp";
          spec-draft-model = "/mnt/llms/Qwen3.8-Flash/mtp-Qwen3.8-Flash-Next-shared-Q8_0.gguf";
          spec-draft-n-max = 2;
          spec-draft-ngl = 99;
          spec-draft-threads = 6;
          spec-draft-cpu-range = "6-11";
          spec-draft-cpu-strict = 1;
          spec-draft-type-k = "q8_0";
          spec-draft-type-v = "q8_0";
        */
        cache-reuse = 256;
        fit = "on";
        #no-sched-async-cpu = true;

        cache-ram = 16384;
        cache-idle-slots = true;

        kv-offload = true;
        kv-unified = true;
        cache-type-k = "q8_0";
        cache-type-v = "q8_0";
        ctx-size = 262144; # 150000; # 131072;
        batch-size = 2048;
        ubatch-size = 512;
        jinja = true;

        temperature = 1.0;
        top-p = 0.95;
        top-k = 20;
        min-p = 0.0;
        presence-penalty = 0.0;
        repeat-penalty = 1.0;
      };
    }
  );

  llama-moe-trace = pkgs.writeShellApplication {
    name = "llama-moe-trace";
    runtimeEnv.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.gcc.cc.lib
    ];
    text = ''
      exec ${pkgs.llama-cpp-codacus}/bin/llama-moe-trace "$@" 
    '';
  };

  create-cache = pkgs.writeShellApplication {
    name = "llama-create-moe-cache";
    runtimeInputs = [
      pkgs.matugen
      pkgs.awww
      pkgs.zenity
      pkgs.sunwait
    ];
    runtimeEnv = {
      HSA_OVERRIDE_GFX_VERSION = "10.3.0";
      HIP_VISIBLE_DEVICES = 0;
      ROC_ENABLE_PRE_VEGA = 1;
      SERVER = "localhost:9931";
      MODEL = "Qwen3.8-Flash";
      BIN = pkgs.lib.getExe llama-moe-trace;
      TRACE_DIR = "/mnt/llms/Qwen3.8-Flash/trace";
    };
    text = builtins.readFile ./localai_trace.sh;
  };

in
{
  options.usecases.localai = {
    enable = mkEnableOption "Enable local LLM services";
  };

  config = mkIf cfg.enable {
    home-manager.users.${username}.home.packages = [
      create-cache
      pkgs.llama-cpp-codacus
      pkgs.opencode
      pkgs.github-copilot-cli
    ];
    systemd.services.llama-cpp.serviceConfig.Environment = [
      "HSA_OVERRIDE_GFX_VERSION=10.3.0"
      "HIP_VISIBLE_DEVICES=0"
      "ROC_ENABLE_PRE_VEGA=1"
    ];
    services = {
      llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-codacus;
        settings = {
          host = "127.0.0.1";
          port = 9931;
          models-max = 1;
          inherit models-preset;
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
