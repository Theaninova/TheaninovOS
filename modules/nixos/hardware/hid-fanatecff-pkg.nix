{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
  linuxConsoleTools,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "hid-fanatecff";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "gotzl";
    repo = "hid-fanatecff";
    rev = version;
    hash = "sha256-M2jm8pyxHRiswV4iJEawo57GkJ2XOclIo3NxEFgK+q0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KVERSION=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KBUILD_OUTPUT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace fanatec.rules \
      --replace-fail "/bin/sh" "${bash}/bin/sh"
    substituteInPlace fanatec.rules \
      --replace-fail "/usr/bin/evdev-joystick" "${linuxConsoleTools}/bin/evdev-joystick"

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc/udev/rules.d
    cp fanatec.rules $out/etc/udev/rules.d/99-fanatec.rules

    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid
    cp hid-fanatec.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid

    runHook postInstall
  '';

  meta = with lib; {
    description = "Driver to support FANATEC input devices, in particular ForceFeedback of various wheel-bases";
    homepage = "https://github.com/gotzl/hid-fanatecff";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ theaninova ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
