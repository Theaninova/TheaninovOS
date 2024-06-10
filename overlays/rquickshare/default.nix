{
  lib,
  stdenv,
  stdenvNoCC,
  rustPlatform,
  fetchFromGitHub,
  buildGoModule,
  wrapGAppsHook3,
  cargo,
  rustc,
  esbuild,
  cargo-tauri,
  pkg-config,
  nodePackages,
  jq,
  moreutils,
  gtk3,
  webkitgtk,
  openssl,
  cacert,
}:
stdenv.mkDerivation rec {
  pname = "rquickshare";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Martichou";
    repo = "rquickshare";
    rev = "v${version}";
    hash = "sha256-T3J91WmXjeB+M11n6oAjyr1SL8/mtIeESNjPe0ZUVLo=";
  };

  sourceRoot = "${src.name}/frontend/src-tauri";

  pnpm-deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit src version;

    sourceRoot = "${src.name}/frontend";

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
      cacert
    ];

    installPhase = ''
      export HOME=$(mktemp -d)
      pnpm config set store-dir $out
      # use --ignore-script and --no-optional to avoid downloading binaries
      # use --frozen-lockfile to avoid checking git deps
      pnpm install --frozen-lockfile --no-optional --ignore-script

      # Remove timestamp and sort the json files
      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-+uQLHy3A8HNMROy1k7L++T47+2a8wkFIFyqioBW/Dvk=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "mdns-sd-0.10.4" = "sha256-y8pHtG7JCJvmWCDlWuJWJDbCGOheD4PN+WmOxnakbE4=";
      # All other crates in the same workspace reuse this hash.
      "tauri-plugin-autostart-0.0.0" = "sha256-uOPFpWz715jT8zl9E6cF+tIsthqv4x9qx/z3dJKVtbw=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri
    wrapGAppsHook3
    nodePackages.pnpm
    pkg-config
  ];

  buildInputs = [
    gtk3
    openssl
    webkitgtk
  ];

  ESBUILD_BINARY_PATH = "${lib.getExe (
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // rec {
            version = "0.19.8";
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-f13YbgHFQk71g7twwQ2nSOGA0RG0YYM01opv6txRMuw=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        );
    }
  )}";

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    pnpm config set store-dir ${pnpm-deps}
    chmod +w ..
    pnpm install --offline --frozen-lockfile --no-optional --ignore-script
    chmod -R +w ../node_modules
    pnpm rebuild
    pnpm tauri build -b deb

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mv target/release/bundle/deb/*/data/usr/ $out
    runHook postInstall
  '';

  meta = {
    description = "Rust implementation of NearbyShare/QuickShare from Android for Linux";
    mainProgram = "r-quick-share";
    homepage = "https://github.com/Martichou/rquickshare";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ theaninova ];
  };
}
