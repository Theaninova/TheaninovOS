{
  lib,
  scdoc,
  buildGoModule,
  fetchFromGitLab,
  hidapi,
  udev,
}:
buildGoModule rec {
  pname = "darkman";
  version = "1.5.4";

  src = fetchFromGitLab {
    owner = "WhyNotHugo";
    repo = "darkman";
    rev = "5332193777fb0c5dbde6cbfd015a16697d6a0c8e";
    hash = "sha256-3TGDy7hiI+z0IrA+d/Q+rMFlew6gipdpXyJ5eVLCmds=";
  };

  vendorHash = "sha256-xEPmNnaDwFU4l2G4cMvtNeQ9KneF5g9ViQSFrDkrafY=";

  nativeBuildInputs = [ scdoc ];

  postPatch = ''
    substituteInPlace darkman.service \
      --replace "/usr/bin/darkman" "$out/bin/darkman"
    substituteInPlace contrib/dbus/nl.whynothugo.darkman.service \
      --replace "/usr/bin/darkman" "$out/bin/darkman"
    substituteInPlace contrib/dbus/org.freedesktop.impl.portal.desktop.darkman.service \
      --replace "/usr/bin/darkman" "$out/bin/darkman"
  '';

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make PREFIX=$out install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Framework for dark-mode and light-mode transitions on Linux desktop";
    homepage = "https://gitlab.com/WhyNotHugo/darkman";
    license = licenses.isc;
    maintainers = [ maintainers.ajgrf ];
    platforms = platforms.linux;
    mainProgram = "darkman";
  };
}
