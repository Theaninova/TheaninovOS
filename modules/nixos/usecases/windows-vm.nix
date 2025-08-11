{
  config,
  lib,
  pkgs,
  username,
  ...
}:

with lib;

let
  cfg = config.usecases.windows-vm;
in
{
  options.usecases.windows-vm = {
    enable = mkEnableOption "Enable Windows VM things";
  };

  config = mkIf cfg.enable {
    programs.dconf.enable = true;

    users.users.${username}.extraGroups = [ "libvirtd" ];

    boot = {
      kernelParams = [
        "amd_iommu=on"
        "iommu=pt"
      ];
    };

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };

    networking.firewall.trustedInterfaces = [ "virbr0" ];

    services = {
      spice-vdagentd.enable = true;
      spice-webdavd.enable = true;
    };
  };
}
