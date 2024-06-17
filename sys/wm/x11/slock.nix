{ lib, stdenv, writeText
, xorgproto, libX11, libXext, libXrandr, libxcrypt, cargo, libXinerama
, fetchFromGitHub
}:
stdenv.mkDerivation {
    pname = "slock";
    version = "1.5";

    src = fetchFromGitHub {
      owner = "omega-800";
      repo = "slock";
      rev = "4267b2d175940500e288a52ec3eebe29075da7e5";
      hash = "sha256-Kb/YslQDgq4gBaa4/YyH9DxWA6uaFQR2vNYGKgSuHoM=";
    };

  buildInputs = [ cargo xorgproto libX11 libXext libXrandr libxcrypt libXinerama ];

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
  };}
