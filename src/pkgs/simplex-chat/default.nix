{
  lib,
  haskell,
  fetchgit,
}:

let
  name = "simplex-chat";
  compiler = "ghc96";
  hlib = haskell.lib;

  fetchOldPkgs =
    rev: sha256:
    (import (fetchgit {
      url = "https://github.com/NixOS/nixpkgs";
      #ref = "refs/heads/nixpkgs-unstable";
      inherit rev sha256;
    }) { system = "x86_64-linux"; }).haskellPackages;

  inherit
    (fetchOldPkgs "c407032be28ca2236f45c49cfb2b8b3885294f7f" "sha256-e5XNMNJ2Z61MEnXeMbGkLqWr0FfgH3y5X+9nV15pJak=")
    http2_4_2_2
    ;

  aeson-pretty_0_8_10 =
    (fetchOldPkgs "05bbf675397d5366259409139039af8077d695ce" "sha256:1r26vjqmzgphfnby5lkfihz6i3y70hq84bpkwd43qjjvgxkcyki0")
    .aeson-pretty;

  inherit
    (fetchOldPkgs "0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb" "sha256-e5XNMNJ2Z61MEnXeMbGkLqWr0FfgH3y5X+9nV15pJak=")
    attoparsec-aeson_2_2_0_1
    ;

  haskellOverrides = self: super: {
    # original
    simplexmq = hlib.dontCheck (hlib.doJailbreak (self.callPackage ./simplex-chat/simplexmq.nix { }));

    # specific versions, already in the package set
    #attoparsec-aeson = super.attoparsec-aeson_2_2_0_1;
    attoparsec-aeson = attoparsec-aeson_2_2_0_1;
    #http2 = self.http2_4_2_2;

    #aeson-pretty = super.aeson-pretty_0_8_10;
    aeson-pretty = aeson-pretty_0_8_10;

    # forks
    direct-sqlcipher = self.callPackage ./simplex-chat/direct-sqlcipher.nix { }; # https://github.com/IreneKnapp/direct-sqlite
    sqlcipher-simple = hlib.dontCheck (self.callPackage ./simplex-chat/sqlcipher-simple.nix { }); # https://github.com/nurpax/sqlite-simple
    aeson = self.callPackage ./simplex-chat/aeson.nix { }; # https://github.com/haskell/aeson
    socks = self.callPackage ./simplex-chat/hs-socks.nix { }; # https://github.com/vincenthz/hs-socks, unmaintained, archived by the original author

    simplex-chat = self.callPackage ./simplex-chat/simplex-chat.nix { };
  };

  hp = haskell.packages."${compiler}".extend haskellOverrides;

  meta = {
    mainProgram = "simplex-chat";
    homepage = "https://simplex.chat";
    description = "Command line version of SimpleX Chat.";
    license = lib.licenses.agpl3;
    maintainers = [ lib.maintainers.eyeinsky ];
    platforms = [ "x86_64-linux" ];
  };

in
(hlib.dontCheck (hlib.doJailbreak hp.simplex-chat)) // { inherit meta; }
