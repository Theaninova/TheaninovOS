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
  wayland.windowManager.hyprland.settings = {
    config = {
      general.layout = "master";
      master = {
        orientation = "right";
        mfact = 0.65;
        always_keep_position = true;
      };
      input.kb_options = [ "lv3:caps_switch" ];
    };
    monitor = [
      {
        output = "eDP-1";
        mode = "3840x2160@60";
        position = "0x0";
        scale = 2;
      }
      {
        output = "HDMI-A-4";
        mode = "2560x1440@75";
        position = "1920x-768";
        scale = 1;
      }
    ];
  };
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

  services.nextcloud-client.enable = true;
}
