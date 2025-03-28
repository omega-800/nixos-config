{ lib, ... }:
let
  inherit (import ./num.nix { inherit lib; }) mod;
  inherit (builtins) isList;
  inherit (lib)
    splitString
    hasSuffix
    removeSuffix
    hasPrefix
    removePrefix
    substring
    fromHexString
    toHexString
    concatMapStrings
    stringToCharacters
    elemAt
    imap0
    ifilter0
    isInt
    toInt
    ;
in
{
  rmSuffix = suffix: name: if (hasSuffix suffix name) then (removeSuffix suffix name) else name;
  rmPrefix = suffix: name: if (hasPrefix suffix name) then (removePrefix suffix name) else name;
  charAt = s: n: substring n (n + 1) s;
  rgb2hex =
    s:
    let
      spl = splitString ",";
      l = map (c: if isInt c then c else toInt c) (
        if (isList s) then
          s
        else if ((hasPrefix "rgb(" s) && (hasSuffix ")" s)) then
          (spl (removeSuffix ")" (removePrefix "rgb(" s)))
        else
          spl s
      );
    in
    "#${concatMapStrings toHexString l}";
  hex2rgb =
    s:
    let
      chars = stringToCharacters (if (hasPrefix "#" s) then (removePrefix "#" s) else s);
      l =
        if isList s then
          s
        else
          imap0 (i: c: "${elemAt chars (i * 2)}${c}") (ifilter0 (i: _: (mod i 2) == 1) chars);
    in
    map fromHexString l;
}
