{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
}:
stdenv.mkDerivation rec {
  pname = "hid-fanatecff-tools";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff-tools";
    rev = "7f9ab82a5e46a60811a9917765ec5d3cdbf0ecbd";
    hash = "sha256-urgAMa3xPe6iYLwXavJ5rtjsbtueUG64XPsAlB1x/Y8=";
  };

  patchPhase = ''
    substituteInPlace "tools/fanatec_led_server.py" --replace "#!/usr/bin/python3" "#!/${pkgs.python312}"
    rm Makefile
  '';

  installPhase = ''
    mkdir -p $out/share/${pname}
    cp . $out/share/${pname}

    mkdir -p $out/bin
    ln -s $out/share/${pname}/tools/fanatec_led_server $out/bin/${pname}

    cp -v dbus/org.fanatec.conf $out/etc/dbus-1/system.d/
    cp -v dbus/org.fanatec.service $out/share/dbus-1/system-services/

    ln -s dbus/fanatec-input.py $out/bin/fanatec-input
    ln -s dbus/fanatec-input.systemd.service $out/lib/systemd/system/fanatec-input.service

  '';

  meta = with lib; {
    description = ''
      Helper to access sysfs functions from the hid-fanatec driver
      and aims to connect games with the (extended) features of
      the CSL Elite Wheel. It is not needed for force-feedback to work.
    '';
    homepage = "https://github.com/gotzl/hid-fanatecff-tools";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
