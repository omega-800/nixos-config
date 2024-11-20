{ lib, ... }:
let
  inherit (lib)
    hasSuffix
    removeSuffix
    hasPrefix
    removePrefix
    substring
    ;
in
{
  rmSuffix = suffix: name: if (hasSuffix suffix name) then (removeSuffix suffix name) else name;
  rmPrefix = suffix: name: if (hasPrefix suffix name) then (removePrefix suffix name) else name;
  charAt = s: n: substring n (n + 1) s;
}
