{ python3Packages }:
with python3Packages;
buildPythonPackage rec {
  pname = "waybar-ha";
  version = "0.0.1";
  format = "pyproject";
  src = ./.;
  buildInputs = [
    setuptools
  ];
  propagatedBuildInputs = [
    requests
    keyring
  ];

  meta.mainProgram = pname;
}
