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
  };

  config = mkIf cfg.enable {
    home-manager.users.${username} =
      let
        name = "Astro A50";
        nick = "A50";
        filter = bitrate: {
          "media.class" = "Audio/Sink";
          "alsa.components" = "USB046d:0b1c";
          "alsa.resolution_bits" = bitrate;
        };
        nodeNameIn = "astro-a50-eq-harman-in";
      in
      {
        home.packages = with pkgs; [ zam-plugins ];
        xdg.configFile = {
          "wireplumber/wireplumber.conf.d/51-astro-a50.conf".text = builtins.toJSON {
            "monitor.alsa.rules" = [
              {
                matches = [ (filter 16) ];
                actions.update-props = {
                  "node.description" = "${name} Chat";
                  "node.nick" = "${nick} Chat";
                };
              }
              {
                matches = [ (filter 24) ];
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
                  "equalizer.filepath" = builtins.toString ./astro-a50-harman.txt;
                  "equalizer.description" = "${name} (Harman EQ)";
                  "capture.props" = {
                    "node.name" = nodeNameIn;
                    "filter.smart" = true;
                    "filter.smart.target" = filter 24;
                  };
                  "playback.props" = {
                    "node.name" = "EQ Output";
                  };
                };
              }
            ];
          };
        };
      };
  };
}
