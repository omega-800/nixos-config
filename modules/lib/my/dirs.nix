{ lib, ... }:
with builtins;
with lib; rec {
  mapFilterDir = mapFn: filterFn: dir:
    mapAttrs'
      (n: v:
        nameValuePair
          (if (hasSuffix ".sh" n) then
            (removeSuffix ".sh" n)
          else if (hasSuffix ".nix" n) then
            (removeSuffix ".nix" n)
          else
            n)
          (mapFn "${toString dir}/${n}"))
      (filterAttrs filterFn (readDir dir));

  listFilterNixModuleNames = filterFn: dir:
    mapAttrsToList (n: v: removeSuffix ".nix" n) (filterAttrs
      (n: v:
        v == "regular" && (hasSuffix ".nix" n) && n != "default.nix"
        && (filterFn n v))
      (readDir dir));

  listNixModuleNames = dir: listFilterNixModuleNames (n: v: true) dir;

  listFilterDirs = filterFn: dir:
    mapAttrsToList (n: v: n)
      (filterAttrs (n: v: v == "directory" && (filterFn n v)) (readDir dir));

  listDirs = dir: listFilterDirs (n: v: true) dir;
}
