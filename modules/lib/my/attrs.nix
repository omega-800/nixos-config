{ lib, ... }: rec {
  filterMapAttrNames = filterFn: mapFn: attrset:
    lib.mapAttrs' (n: v: lib.nameValuePair (mapFn n) v)
      (lib.filterAttrs filterFn attrset);

  mapAttrNames = mapFn: attrset: filterMapAttrNames attrset (n: v: true) mapFn;

  mapListToAttrs = fun: items: lib.mkMerge (builtins.concatMap fun items);
}
