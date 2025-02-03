{
  pkgs,
  lib,
  config,
  ...
}:
with lib;

let
  cfg = config.hardware.amdgpu.preset.default;
in
{
  options.hardware.amdgpu.preset.default = {
    enable = mkEnableOption "Enable ADM GPU driver support with some sane defaults";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };

    systemd.tmpfiles.rules =
      let
        rocmEnv = pkgs.symlinkJoin {
          name = "rocm-combined";
          paths = with pkgs.rocmPackages; [
            rocblas
            hipblas
            clr
          ];
        };
      in
      [
        "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
      ];

    boot = {
      # https://docs.kernel.org/gpu/amdgpu/module-parameters.html
      kernelParams = [
        "amdgpu.seamless=1"
        "amdgpu.freesync_video=1"
      ];
      initrd.kernelModules = [ "amdgpu" ];
    };

    environment.systemPackages = with pkgs; [
      amdgpu_top
      glxinfo
      libva-utils
      vulkan-tools
      clinfo
    ];
  };
}
