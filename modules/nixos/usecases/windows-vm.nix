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

    # WARN: sometimes the VM will place hard-coded/hashed paths in the config,
    # which breaks after NixOS updates because hashes change.
    # The error might look something like
    # "Unable to find efi firmware that is compatible with the current configuration".
    # To fix this, manually edit the VM config in the VM manager in the XML tab of the Boot Options.
    # Replace
    #  <loader readonly="yes" secure="yes" type="pflash" format="raw">/nix/store/yd1rlziy0cnjjp78zc7wr9dcv5hah16w-qemu-10.1.0/share/qemu/edk2-x86_64-secure-code.fd</loader>
    #  <nvram template="/nix/store/yd1rlziy0cnjjp78zc7wr9dcv5hah16w-qemu-10.1.0/share/qemu/edk2-i386-vars.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>
    # with
    #  <loader readonly="yes" secure="yes" type="pflash" format="raw">/run/libvirt/nix-ovmf/edk2-x86_64-secure-code.fd</loader>
    #  <nvram template="/run/libvirt/nix-ovmf/edk2-i386-vars.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      virtio-win
      win-spice
      adwaita-icon-theme
      qemu
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
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
