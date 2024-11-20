{ lib, ... }:
let
  inherit (import ./num.nix { inherit lib; }) digits pow;
  inherit (import ./str.nix { inherit lib; }) charAt;
  inherit (lib)
    splitString
    flatten
    toInt
    replicate
    concatStrings
    toHexString
    ;
  inherit (builtins) elemAt;
in
{
  ip4 = rec {
    ipFromCfg = net: ipFromList (net.network ++ [ net.id ] ++ [ net.prefix ]);
    ipFromList = l: ip (elemAt l 0) (elemAt l 1) (elemAt l 2) (elemAt l 3) (elemAt l 4);
    ip = a: b: c: d: prefixLength: {
      inherit
        a
        b
        c
        d
        prefixLength
        ;
      address = "${toString a}.${toString b}.${toString c}.${toString d}";
    };

    prefix0 = x: concatStrings (replicate (3 - (digits x)) "0");
    with0Prefix = x: "${prefix0 x}${toString x}";
    firstHexChar = x: charAt (toHexString x) 0;

    toHostId = ip: with ip; "${with0Prefix a}${firstHexChar b}${firstHexChar c}${with0Prefix d}";
    toCIDR = addr: "${addr.address}/${toString addr.prefixLength}";
    toNetworkAddress = addr: {
      inherit (addr) address prefixLength;
    };
    toNumber = addr: with addr; a * 16777216 + b * 65536 + c * 256 + d;
    fromNumber =
      addr: prefixLength:
      let
        aBlock = a * 16777216;
        bBlock = b * 65536;
        cBlock = c * 256;
        a = addr / 16777216;
        b = (addr - aBlock) / 65536;
        c = (addr - aBlock - bBlock) / 256;
        d = addr - aBlock - bBlock - cBlock;
      in
      ip a b c d prefixLength;

    fromString =
      str:
      let
        splits1 = splitString "." str;
        splits2 = flatten (map (x: splitString "/" x) splits1);
        e = i: toInt (elemAt splits2 i);
      in
      ip (e 0) (e 1) (e 2) (e 3) (e 4);

    fromIPString = str: prefixLength: fromString "${str}/${toString prefixLength}";

    network =
      addr:
      let
        pfl = addr.prefixLength;
        shiftAmount = pow 2 (32 - pfl);
      in
      fromNumber ((toNumber addr) / shiftAmount * shiftAmount) pfl;
  };

}
