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
}:
stdenv.mkDerivation {
  pname = "slock";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "omega-800";
    repo = "slock";
    rev = "56e5114cdd30136c2c93a768561c8fa5ea624e26";
    hash = "sha256-nURLfUR155KgpkPt2DIFOI34oB5OqS5yXUsRKnTjb50=";
  };

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
