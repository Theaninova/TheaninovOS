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
    packages = with pkgs; [ blueman ];
  };
  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1,3840x2160@60,0x0,2,bitdepth,10,cm,auto"
    "HDMI-A-4,2560x1440@75,1920x-768,1,bitdepth,10,cm,auto"
  ];
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
