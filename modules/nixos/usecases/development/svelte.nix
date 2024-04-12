{ config, lib, ... }:

with lib;

let
  cfg = config.usecases.development.svelte;
in
{
  options.usecases.development.svelte = {
    enable = mkEnableOption "Enable Svelte develompent";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      5073
      5173
    ];
  };
}
