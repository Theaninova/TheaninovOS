{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.hardware.audio.preset.pipewire;
in
{
  options.hardware.audio.preset.pipewire = {
    enable = mkEnableOption "pipewire with sane defaults";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pavucontrol ];
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
