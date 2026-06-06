{ pkgs, ... }:
{
  theme.md3-evo = {
    enable = true;
    auto-dark = {
      enable = true;
      lat = 52.52;
      lon = 13.40;
    };
  };
  programs.zoxide.enable = true;
  home = {
    packages = with pkgs; [
      blueman
      kdePackages.okular
      bitbox
      gamma-launcher
    ];
  };
  wayland.windowManager.hyprland.settings.config.input.kb_options = [ "lv3:caps_switch" ];
  services.nextcloud-client.enable = true;
  systemd.user.services = {
    nm-applet = {
      Unit = {
        Description = "Network manager applet";
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
        Restart = "always";
      };
    };
    blueman-applet = {
      Unit = {
        Description = "Bluetooth manager applet";
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.blueman}/bin/blueman-applet";
        Restart = "always";
      };
    };
  };
}
