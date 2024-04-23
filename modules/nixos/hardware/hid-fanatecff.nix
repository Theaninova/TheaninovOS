{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.hardware.hid-fanatecff;
  kernelPackage = pkgs.callPackage ./hid-fanatecff-pkg.nix {
    kernel = config.boot.kernelPackages.kernel;
  };
in
{
  options.hardware.hid-fanatecff.enable = lib.mkEnableOption "the Linux kernel drivers for Fanatec wheel bases";

  config = lib.mkIf cfg.enable {
    boot = {
      extraModulePackages = [ kernelPackage ];
      kernelModules = [ "hid-fanatec" ];
    };
    services.udev.packages = [ kernelPackage ];
    users.groups.games = { };
  };

  meta = {
    maintainers = with lib.maintainers; [ theaninova ];
  };
}
