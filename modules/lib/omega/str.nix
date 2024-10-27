{ lib, ... }:
let inherit (lib) hasSuffix removeSuffix hasPrefix removePrefix;
in {
  rmSuffix = suffix: name:
    if (hasSuffix suffix name) then (removeSuffix suffix name) else name;
  rmPrefix = suffix: name:
    if (hasPrefix suffix name) then (removePrefix suffix name) else name;
}
