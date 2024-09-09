{ lib, ... }:
with builtins;
with lib; {
  mapFilterDir = dir: mapFn: filterFn:
    mapAttrs' (n: v:
      nameValuePair
      (if (hasSuffix ".nix" n) then (removeSuffix ".nix" n) else n)
      (mapFn "${toString dir}/${n}")) (filterAttrs filterFn (readDir dir));
}
