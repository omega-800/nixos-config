{ lib, ... }: rec {
  filterMapAttrNames = filterFn: mapFn: attrset:
    lib.listToAttrs (map
      (i: {
        name = mapFn i.name;
        inherit (i) value;
      })
      (lib.attrsToList (lib.filterAttrs filterFn attrset)));

  mapAttrNames = mapFn: attrset: filterMapAttrNames attrset (n: v: true) mapFn;
}
