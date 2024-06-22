with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "wellhellothere";
  src = ./.;
  installPhase = "echo -e '#!/bin/sh \n echo Hello' > $out";
}

