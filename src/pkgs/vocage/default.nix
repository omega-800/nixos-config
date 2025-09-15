{ rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "vocage";
  version = "v1.1.0";
  src = fetchFromGitHub {
    tag = version;
    owner = "proycon";
    repo = pname;
    fetchSubmodules = false;
    sha256 = "sha256-mKMP/ElSipgeAlactNwqE4vCKvqVsemmu99gpi4CWiY=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = { };
  };
}
