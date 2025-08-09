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
    ];
  };
  systemd.user.services = {
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
