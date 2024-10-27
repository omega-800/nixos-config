{
  lib,
  rustPlatform,
  fetchurl,
  fetchFromGitHub,
  pkg-config,
  scdoc,
  libgcc,
  systemd,
}:
rustPlatform.buildRustPackage rec {
  pname = "swhkd";
  version = "1.2.1-unstable-2024-04-06";

  # split-output derivation, since there's a fair amount of associated data for
  # pkexec and such.
  outputs = [
    "bin"
    "man"
    "out"
  ];

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "swhkd";
    # build from master, since the 1.2.1 makefile is unsutible for packaging
    rev = "7999a9bcf55e72455afc8c6dbd7c856d54435352";
    hash = "sha256-uXoeVoq6mJkLhDo3l7O0wSCRT/njSHjMXLWHLETiHoo=";
  };

  nativeBuildInputs = [
    scdoc
    pkg-config
  ];

  # the makefile tries to set the ownership of a file to root.
  # this will fail, but files are owned by root anyways.
  postPatch = ''
    sed -ie 's/-o root//' Makefile
  '';

  buildPhase = ''
    runHook preBuild
    make build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out $bin $man/share
    make DESTDIR=$out MAN1_DIR=/share/man/man1 MAN5_DIR=/share/man/man5 TARGET_DIR=/bin install
    mv $out/bin $bin/bin
    mv $out/share/man $man/share/man
    mv $out/usr/share/polkit-1 $out/share/polkit-1
    rm -r $out/etc $out/usr

    runHook postInstall
  '';

  cargoHash = "sha256-d/61hdyooYuqfOSTUcxVUJVhG98uexgPk7h6N1ptIgQ=";

  buildInputs = [
    systemd
    libgcc
  ];

  meta = with lib; {
    description = "A drop-in replacement for sxhkd that works with wayland";
    homepage = "https://github.com/waycrate/swhkd";
    changelog = "https://github.com/waycrate/swhkd/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ binarycat ];
  };
}
