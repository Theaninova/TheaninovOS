{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib;

let
  cfg = config.hardware.pimax;
in
{
  options.hardware.pimax = {
    enable = mkEnableOption "";
  };

  config = mkIf cfg.enable (
    let
      monado-pimax =
        # https://gitlab.freedesktop.org/Coreforge/monado/-/commits/pimax?ref_type=heads
        pkgs.monado.overrideAttrs {
          pname = "monado-pimax";
          patches = [ ];
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "Coreforge";
            repo = "monado";
            rev = "f858ee5dd8ca7696bd9219e8278f2671df56fe6e";
            hash = "sha256-Si56yvG+oSfyUaPAlF1FgB7WJo8td1xuVxYnkJvbu4o=";
          };
        };
      monado-pimax-new =
        # https://gitlab.freedesktop.org/Coreforge/monado/-/commits/pimax?ref_type=heads
        pkgs.monado.overrideAttrs {
          pname = "monado-pimax";
          patches = [ ];
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.freedesktop.org";
            owner = "Coreforge";
            repo = "monado";
            rev = "f712f680dd57753a31d2605ae1505b06f30d50eb";
            hash = "sha256-ke7UXimIvPBDvBU7RV7Q8fAum5LYnHC64NLA7x3XftU=";
          };
        };
    in
    {
      environment.systemPackages = with pkgs; [
        opencomposite
      ];

      home-manager.users."${username}".xdg.configFile = {
        "openxr/1/active_runtime.json".source = "${monado-pimax}/share/openxr/1/openxr_monado.json";
        "openvr/openvrpaths.vrpath".text = builtins.toJSON {
          config = [ "~/.local/share/Steam/config" ];
          external_drivers = null;
          jsonid = "vrpathreg";
          log = [ "~/.local/share/Steam/logs" ];
          runtime = [ "${pkgs.opencomposite}/lib/opencomposite" ];
          version = 1;
        };
      };

      boot.kernelPatches = [
        {
          name = "pimax-quirks";
          patch = ./pimax.patch;
        }
        {
          name = "amdgpu-ignore-ctx-privileges";
          patch = pkgs.fetchpatch {
            name = "cap_sys_nice_begone.patch";
            url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
            hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
          };
        }
      ];

      services.monado = {
        enable = true;
        defaultRuntime = true;
        highPriority = true;
        package = monado-pimax;
      };

      systemd.user.services.monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
      };
    }
  );
}
