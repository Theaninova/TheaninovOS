{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.hardware.hid-fanatecff;
  kernel = config.boot.kernelPackages.kernel;
  fanatecKernelModule = pkgs.callPackage (import ./hid-fanatecff-module.nix) {kernel = kernel;};
in {
  options.hardware.hid-fanatecff = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mkDoc ''
        Enables the Linux module drivers for Fanatec wheel bases.
        Works with the CSL Elite and CSL/ClubSport DD/DD Pro,
        and has experimental support for the ClubSport V2/V2.5,
        Podium DD1/DD2 and CSR Elite.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = [fanatecKernelModule];
      kernelModules = ["hid-fanatecff"];
    };
  };
}
