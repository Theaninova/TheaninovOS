{ pkgs, lib, config, ... }:
with lib;

let cfg = config.hardware.virtual-camera;

in {
  options.hardware.virtual-camera = {
    enable = mkEnableOption "Enable the virtual camera";
  };

  config = mkIf cfg.enable {
    boot = {
      # Virtual Camera/Mic
      kernelModules = [ "v4l2loopback" "snd-aloop" "sg" ];
      extraModulePackages = with config.boot.kernelPackages;
        [ v4l2loopback.out ];
      extraModprobeConfig = ''
        options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      '';
    };
  };
}
