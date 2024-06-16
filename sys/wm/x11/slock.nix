{ lib, stdenv, writeText
, xorgproto, libX11, libXext, libXrandr, libxcrypt
, fetchFromGitHub
, conf ? null
}:
stdenv.mkDerivation {
    pname = "slock";
    version = "1.5";

    src = fetchFromGitHub {
      owner = "omega-800";
      repo = "slock";
      ref = "main";
      rev = "6fa28f6895b0ccbdaf7d8c9806359ccd28cc8a91";
      hash = "sha256-zyGyZOG8gAtsRkzSRH1M777fPv1wudbVsBrSTJ5CBnY=";
    };

  buildInputs = [ xorgproto libX11 libXext libXrandr libxcrypt ];

  installFlags = [ "PREFIX=$(out)" ];

  postPatch = "sed -i '/chmod u+s/d' Makefile";

  preBuild = lib.optionalString (conf != null) ''
    cp ${writeText "config.def.h" conf} config.def.h
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
