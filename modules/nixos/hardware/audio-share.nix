{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib;

let
  cfg = config.hardware.audio.audio-share;
in
{
  options.hardware.audio.audio-share = {
    enable = mkEnableOption "LAN Audio Sharing";
    partner = mkOption {
      type = types.submodule {
        options = {
          ip = mkOption {
            type = types.str;
            description = "The IP address of the partner machine to share audio with.";
          };
          name = mkOption {
            type = types.str;
            description = "Name of the partner machine (for display purposes)";
          };
          combine = mkOption {
            type = types.str;
            description = "Name of the sink to combine the shared output with";
          };
        };
      };
    };
  };

  config =
    let
      sourcePort = 10001;
      repairPort = 10002;
      controlPort = 10003;
      sinkName = "combined_output_3";
    in
    mkIf cfg.enable {
      networking.firewall.allowedUDPPorts = [
        sourcePort
        repairPort
        controlPort
      ];
      home-manager.users.${username} = {
        programs.waybar.settings.mainBar = {
          "pulseaudio" = {
            format-icons.${sinkName} = "󱝉";
            on-click-right = lib.getExe (
              pkgs.writeShellApplication {
                name = "toggle-audio-share";
                runtimeEnv = {
                  SINK_A = sinkName;
                  SINK_B = cfg.partner.combine;
                };
                text = builtins.readFile ./audio-share.sh;
              }
            );
          };
        };
        xdg.configFile = {
          "pipewire/pipewire.conf.d/52-audio-share.conf".text = builtins.toJSON {
            "context.modules" = [
              {
                name = "libpipewire-module-roc-source";
                args = {
                  "local.ip" = "0.0.0.0";
                  "roc.resampler.backend" = "default";
                  "roc.resampler.profile" = "default";
                  "roc.latency-tuner.backend" = "default";
                  "roc.latency-tuner.profile" = "default";
                  "fec.code" = "default";
                  "sess.latency.msec" = 100;
                  "local.source.port" = sourcePort;
                  "local.repair.port" = repairPort;
                  "local.control.port" = controlPort;
                };
              }
            ];
          };
          "pipewire/pipewire.conf.d/52-audio-share-sink.conf".text = builtins.toJSON {
            "context.modules" = [
              {
                name = "libpipewire-module-roc-sink";
                args = {
                  "fec.code" = "default";
                  "remote.ip" = cfg.partner.ip;
                  "remote.source.port" = sourcePort;
                  "remote.repair.port" = repairPort;
                  "remote.control.port" = controlPort;
                  "sink.props" = {
                    "node.name" = cfg.partner.name;
                    "node.description" = cfg.partner.name;
                  };
                };
              }
              {
                name = "libpipewire-module-combine-stream";
                args = {
                  "combine.mode" = "sink";
                  "node.name" = sinkName;
                  "node.description" = "Shared Audio Output";
                  "combine.latency-compensate" = true;
                  "combine.props" = {
                    audio.position = [
                      "FL"
                      "FR"
                    ];
                  };

                  "stream.rules" =
                    let
                      actions = {
                        create-stream = {
                          "combine.audio.position" = [
                            "FL"
                            "FR"
                          ];
                          "audio.position" = [
                            "FL"
                            "FR"
                          ];
                        };
                      };
                    in
                    [
                      {
                        matches = [
                          {
                            "media.class" = "Audio/Sink";
                            "node.name" = cfg.partner.combine;
                          }
                        ];
                        inherit actions;
                      }
                      {
                        matches = [
                          {
                            "media.class" = "Audio/Sink";
                            "node.name" = cfg.partner.name;
                          }
                        ];
                        inherit actions;
                      }
                    ];
                };
              }
            ];
          };
        };
      };
    };
}
