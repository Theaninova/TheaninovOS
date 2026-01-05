{
  lib,
  config,
  username,
  pkgs,
  ...
}:
with lib;

let
  cfg = config.hardware.astro-a50;
in
{
  options.hardware.astro-a50 = {
    enable = mkEnableOption "Enable optimisations for the Logitech Astro A50 headset";
    sinkWhenDocked = mkOption {
      type = types.nullOr types.str;
      description = "The PipeWire sink name to switch to when the Astro A50 is docked. If null, no switching will be done.";
      default = "alsa_output.pci-0000_0a_00.4.analog-stereo";
    };
  };

  config =
    let
      name = "Astro A50";
      nick = "A50";
      pipewireFilter = bitrate: {
        "media.class" = "Audio/Sink";
        "alsa.components" = "USB046d:0b1c";
        "alsa.resolution_bits" = bitrate;
      };
      serviceName = "astro-a50-dock-detection";
      nodeNameIn = "astro-a50-eq-harman-in";
      hidrawName = "hidraw_astro_a50";
      hidrawPath = "/dev/${hidrawName}";
      deviceUnit = "dev-${hidrawName}.device";
    in

    mkIf cfg.enable {
      services.udev.extraRules = lib.strings.join ", " [
        "KERNEL==\"hidraw*\""
        "ATTRS{idVendor}==\"046d\""
        "ATTRS{idProduct}==\"0b1c\""
        "MODE=\"0660\""
        "GROUP=\"input\""
        "TAG+=\"systemd\""
        "SYMLINK+=\"${hidrawName}\""
      ];
      users.extraGroups.input.members = [ username ];
      home-manager.users.${username} = {
        home.packages = with pkgs; [ zam-plugins ];
        xdg.configFile = {
          "wireplumber/wireplumber.conf.d/51-astro-a50.conf".text = builtins.toJSON {
            "monitor.alsa.rules" = [
              {
                matches = [ (pipewireFilter 16) ];
                actions.update-props = {
                  "node.description" = "${name} Chat";
                  "node.nick" = "${nick} Chat";
                };
              }
              {
                matches = [ (pipewireFilter 24) ];
                actions.update-props = {
                  "node.description" = name;
                  "node.nick" = nick;
                };
              }
            ];
          };
          "pipewire/pipewire.conf.d/51-a50-eq.conf".text = builtins.toJSON {
            "context.modules" = [
              {
                name = "libpipewire-module-parametric-equalizer";
                args = {
                  "equalizer.filepath" = toString ./astro-a50-harman.txt;
                  "equalizer.description" = "${name} (Harman EQ)";
                  "capture.props" = {
                    "node.name" = nodeNameIn;
                    "filter.smart" = true;
                    "filter.smart.target" = pipewireFilter 24;
                  };
                  "playback.props"."node.name" = "EQ Output";
                };
              }
            ];
          };
        };
        systemd.user.services.${serviceName} = mkIf (cfg.sinkWhenDocked != null) {
          Unit = {
            Description = "Astro A50 Dock Detection";
            StopPropagatedFrom = [ deviceUnit ];
          };
          Install.WantedBy = [
            "default.target"
            deviceUnit
          ];
          Service = {
            Restart = "always";
            RestartSec = "5";
            ExecStart = "-${
              lib.getExe (
                pkgs.writeShellApplication {
                  name = "astro-dock-detect";
                  runtimeEnv = {
                    HID_DEVICE = hidrawPath;
                    HEADSET_NAME = nodeNameIn;
                    SPEAKERS_NAME = cfg.sinkWhenDocked;
                  };
                  text = builtins.readFile ./astro-a50-dock.sh;
                }
              )
            }";
          };
        };
      };
    };
}
