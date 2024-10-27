with import <nixpkgs>;
{
  stdenv,
  dpkg,
  glibc,
  gcc-unwrapped,
  autoPatchelfHook,
}:
let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "1.2.3";

  src = ./RemoteDesktopManager_2024.1.2.3_amd64.deb;

in
stdenv.mkDerivation {
  name = "rdm-${version}";

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
  ];

  # Required at running time
  buildInputs = [
    glibc
    gcc-unwrapped
  ];

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/opt/devolutions/RemoteDesktopManager/* $out
    rm -rf $out/opt
  '';

  meta = with stdenv.lib; {
    description = "RemoteDesktopManager";
    homepage = "https://devolutions.net/remote-desktop-manager/";
    license = licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
