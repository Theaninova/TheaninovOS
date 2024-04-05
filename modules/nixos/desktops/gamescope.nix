{
  config,
  lib,
  pkgs,
  username,
  ...
}:

with lib;

let
  cfg = config.desktops.gamescope;
in
{
  options.desktops.gamescope.enable = mkEnableOption "Enable the SteamOS Compositor as a desktop environment";

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--hide-cursor-delay"
          "3000"
          "--fadee-out-duration"
          "200"
          "--xwayland-count"
          "2"
          "-W"
          (placeholder "SCREEN_WIDTH")
          "-H"
          (placeholder "SCREEN_HEIGHT")
        ];
      };
    };

    /*
      services = {
        greetd = {
          enable = true;
          settings = rec {
            initial_session = {
              command = "${pkgs.hyprland}/bin/Hyprland &> /dev/null";
              user = username;
            };
            default_session = "${pkgs.greetd.tuigreet}/bin/tuigreet";
          };
        };

        dbus.enable = true;

        pcscd.enable = true;

        # nautilus on non-gnome
        gvfs.enable = true;
        # fix pinentry on non-gnome
        dbus.packages = with pkgs; [ gcr ];
        gnome.gnome-online-accounts.enable = true;
        gnome.evolution-data-server.enable = true;
      };

      programs = {
        hyprland.enable = true;
        kdeconnect.enable = true;
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    */
  };
}
