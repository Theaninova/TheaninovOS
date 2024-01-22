{
reema Web is a web client for Threema, a privacy-focussed end-to-end encrypted mobile messenger hosted and developed in Switzerland";
      homepage = "https://threema.ch/en/faq/threema_web";
      license = licenses.agpl3;
      maintainers = with maintainers; [theaninova];
    };
  };
in
  buildNpmPackage rec {
    name = "threema-desktop";
    version = "1.2.40";
    src =
      fetchFromGitHub {
        owner = "threema-ch";
        repo = "threema-web-electron";
        rev = version;
      }
      + "/app";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    buildInputs = [
      (threema-web.overrideAttrs {
        patches = [
          "${src}/../tools/patches/patch-looks.patch"
          "${src}/../tools/patches/patch-user-agent.patch"
        ];
        postBuild = ''
          # see tools/patches/post-patch-threema-web.sh
          sed -i.bak -E "s/IN_MEMORY_SESSION_PASSWORD:(true|false|0|1|\!0|\!1)/IN_MEMORY_SESSION_PASSWORD:true/g" -- *.bundle.js
        '';
      })
    ];
    buildPhase = ''
      run hook preBuild
      ln -s ${threema-web}/share/threema-web ${src}/dependencies/threema-web/release/threema-web
      run hook postBuild
    '';
  }
