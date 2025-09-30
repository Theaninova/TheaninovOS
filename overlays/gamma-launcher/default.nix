{
  lib,
  python3Packages,
  fetchFromGitHub,
  unrar,
}:
python3Packages.buildPythonApplication rec {
  pname = "gamma-launcher";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "Mord3rca";
    repo = "gamma-launcher";
    rev = "v${version}";
    hash = "sha256-qzjfgDFimEL6vtsJBubY6fHsokilDB248WwHJt3F7fI=";
  };

  pyproject = true;

  buildInputs = [ python3Packages.setuptools ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    cloudscraper
    gitpython
    platformdirs
    py7zr
    unrardll
    requests
    tenacity
    tqdm
    (python3Packages.buildPythonPackage rec {
      pname = "python-unrar";
      version = "0.4";

      format = "setuptools";

      src = fetchFromGitHub {
        owner = "matiasb";
        repo = "python-unrar";
        rev = "v${version}";
        hash = "sha256-JeuMDwKltpp2i7rkGiQ5yAOIEtiUdfhOJGDVAGGib+A=";
      };

      patchPhase = ''
        substituteInPlace unrar/unrarlib.py \
          --replace-fail "os.environ.get('UNRAR_LIB_PATH', None)" "r'${unrar}/lib/libunrar.so'" 
      '';

      pythonImportsCheck = [ "unrar" ];

      meta = with lib; {
        description = "Work with RAR archive files through unrar library using ctypes";
        homepage = "https://github.com/matiasb/python-unrar";
        license = licenses.gpl3;
        maintainers = with maintainers; [ theaninova ];
      };
    })
  ];

  meta = with lib; {
    description = "This is a reimplementation of G.A.M.M.A. launcher used for the first setup";
    homepage = "https://github.com/Mord3rca/gamma-launcher";
    license = licenses.gpl3;
    maintainers = with maintainers; [ theaninova ];
  };
}
