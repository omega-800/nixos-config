{
  libX11,
  libXft,
  ncurses,
  fontconfig,
  freetype,
  pkg-config,
  stdenv,
  fetchFromGitHub,
}:
# FIXME: use st from nixpkgs with custom patches passed as args instead
stdenv.mkDerivation rec {
  pname = "st";
  version = "1.0.0";

  nativeBuildInputs = [
    pkg-config
    ncurses
    fontconfig
    freetype
  ];
  buildInputs = [
    libX11
    libXft
  ];
  outputs=["out" "terminfo"];
  strictDeps = true;
  makeFlags = ["PKG_CONFIG=${stdenv.cc.targetPrefix}pkg-config"];
  preInstall = ''
    export TERMINFO=$terminfo/share/terminfo
    mkdir -p $TERMINFO $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';
  installFlags = ["PREFIX=$(out)"];

  src = fetchFromGitHub {
    owner = "omega-800";
    repo = pname;
    rev = "f339235f5c99e02c88fd54ac6a2f3827d120480d";
    fetchSubmodules = false;
    sha256 = "sha256-Mt8zxf7Yca5WkdszNMZa0LOYUF3MPMyA1o/L1fPfWRQ=";
  };
  meta.mainProgram="st";
}
