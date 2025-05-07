{ pkgs, homeDirectory, ... }:
{
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
    # fix pinentry on non-gnome with this in
    # the system config: services.dbus.packages = with pkgs; [ gcr ];
    gnome-keyring.enable = true;
  };
}
