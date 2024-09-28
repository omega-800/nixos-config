{ lib, ... }:
with builtins;
with lib; {
  mapFilterDir = mapFn: filterFn: dir:
    mapAttrs'
      (n: v:
        nameValuePair
          (if (hasSuffix ".nix" n) then (removeSuffix ".nix" n) else n)
          (mapFn "${toString dir}/${n}"))
      (filterAttrs filterFn (readDir dir));

  listFilterNixModuleNames = filterFn: dir:
    mapAttrsToList (n: v: removeSuffix ".nix") (filterAttrs
      (n: v: v == "regular" && (hasSuffix ".nix" n) && (filterFn n v))
      (readDir dir));

  listNixModuleNames = dir: listFilterNixModules (n: v: true) dir;

  listFilterDirs = filterFn: dir:
    mapAttrsToList (n: v: n)
      (filterAttrs (n: v: v == "directory" && (filterFn n v)) (readDir dir));

  listDirs = dir: listFilterDirs (n: v: true) dir;
}
