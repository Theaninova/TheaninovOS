{pkgs}:
pkgs.threema-desktop.overrideAttrs (prev: {
  postFixup =
    prev.postFixup
    + ''
      echo "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" >> $out/bin/threema
    '';
})
