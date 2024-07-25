{ lib
, stdenv
, writeText
, xorgproto
, libX11
, libXext
, libXrandr
, libxcrypt
, cargo
, libXinerama
, fetchFromGitHub
, omega-slock
}:
stdenv.mkDerivation {
  pname = "slock";
  version = "1.5";

  src = omega-slock;
  buildInputs =
    [ cargo xorgproto libX11 libXext libXrandr libxcrypt libXinerama ];

  installFlags = [ "PREFIX=$(out)" ];

  postPatch = "sed -i '/chmod u+s/d' Makefile";

  preBuild = ''
    cp config.def.h config.h
  '';

  makeFlags = [ "CC:=$(CC)" ];

  meta = with lib; {
    homepage = "https://tools.suckless.org/slock";
    description = "Simple X display locker";
    mainProgram = "slock";
    longDescription = ''
      Simple X display locker. This is the simplest X screen locker.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ astsmtl qusic ];
    platforms = platforms.linux;
  };
}
