{ lib, ... }:
let
  inherit (lib)
    mapAttrs'
    nameValuePair
    hasSuffix
    removeSuffix
    filterAttrs
    mapAttrsToList
    ;
  inherit (builtins) readDir;
in
rec {
  mapDir = mapFn: dir: mapFilterDir mapFn (_: _: true) dir;

  mapFilterDir' =
    mapFn: filterFn: dir:
    mapAttrs' (
      n: _:
      nameValuePair (
        if (hasSuffix ".sh" n) then
          (removeSuffix ".sh" n)
        else if (hasSuffix ".nix" n) then
          (removeSuffix ".nix" n)
        else
          n
      ) (mapFn n)
    ) (filterAttrs filterFn (readDir dir));

  mapFilterDir =
    mapFn: filterFn: dir:
    mapAttrs' (
      n: _:
      nameValuePair (
        if (hasSuffix ".sh" n) then
          (removeSuffix ".sh" n)
        else if (hasSuffix ".nix" n) then
          (removeSuffix ".nix" n)
        else
          n
      ) (mapFn "${toString dir}/${n}")
    ) (filterAttrs filterFn (readDir dir));

  listFilterNixModuleNames =
    filterFn: dir:
    mapAttrsToList (n: _: removeSuffix ".nix" n) (
      filterAttrs (n: v: v == "regular" && (hasSuffix ".nix" n) && n != "default.nix" && (filterFn n v)) (
        readDir dir
      )
    );

  listNixModuleNames = dir: listFilterNixModuleNames (_: _: true) dir;

  listFilterDirs =
    filterFn: dir:
    mapAttrsToList (n: _: n) (filterAttrs (n: v: v == "directory" && (filterFn n v)) (readDir dir));

  listDirs = dir: listFilterDirs (_: _: true) dir;
}
