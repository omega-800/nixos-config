{
  stdenv,
  fetchFromGitHub,
  gawk,
  findutils,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "wikiman";
  version = "2.13.2";

  nativeBuildInputs = [
    gawk
    findutils
  ];

  patches = [ ./wikiman-Makefile.diff ];

  buildPhase = ''
    export WORKDIR="$(mktemp -d)" 
    cp -r $src/* $WORKDIR
    make all
  '';

  installPhase = ''
    make install
  '';

  src = fetchFromGitHub {
    owner = "filiparag";
    repo = pname;
    rev = version;
    fetchSubmodules = false;
    sha256 = "sha256-gk/9PVIRw9OQrdCSS+LcniXDYNcHUQUxZ2XGQCwpHaI=";
  };

  meta = {
    homepage = "https://github.com/filiparag/wikiman";
    description = "Wikiman is an offline search engine for manual pages, Arch Wiki, Gentoo Wiki and other documentation.";
    licenses = with lib.licenses; [
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = [
      {
        github = "omega-800";
        githubId = 50942480;
        name = "omega";
      }
    ];
  };
}
