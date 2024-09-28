{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "wellhellothere";
  src = ./.;
  installPhase = ''
    echo -e '#!/bin/sh 
     echo Hello' > $out'';
}
