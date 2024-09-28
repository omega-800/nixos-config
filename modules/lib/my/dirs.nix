{ lib, ... }:
with builtins;
with lib; {
  mapFilterDir = dir: mapFn: filterFn:
    mapAttrs'
      (n: v:
        nameValuePair
          (if (hasSuffix ".nix" n) then (removeSuffix ".nix" n) else n)
          (mapFn "${toString dir}/${n}"))
      (filterAttrs filterFn (readDir dir));

  listFilterNixModules = dir: filterFn:
    mapAttrsToList (n: v: removeSuffix ".nix") (filterAttrs
      (n: v: v == "regular" && (hasSuffix ".nix" n) && (filterFn n v))
      (readDir dir));

  listNixModules = dir: listFilterNixModules dir (n: v: true);

  listFilterDirs = dir: filterFn:
    mapAttrsToList (n: v: n)
      (filterAttrs (n: v: v == "directory" && (filterFn n v)) (readDir dir));

  listDirs = dir: listFilterDirs dir (n: v: true);
}
