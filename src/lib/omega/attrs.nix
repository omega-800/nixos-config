{ lib, ... }:
rec {

  filterMapAttrNames =
    filterFn: mapFn: attrset:
    lib.mapAttrs' (n: v: lib.nameValuePair (mapFn n) v) (lib.filterAttrs filterFn attrset);

  mapAttrNames = mapFn: attrset: filterMapAttrNames attrset (n: v: true) mapFn;

  flatMapToAttrs = fun: items: lib.mkMerge (builtins.concatMap fun items);
  # flatMapToAttrs = mapFn: items: lib.mkMerge (flatMap mapFn items);
  # flatMap = mapFn: items: lib.flatten (map mapFn items);
}
