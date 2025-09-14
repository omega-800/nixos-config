{ lib, ... }:
let
  inherit (lib)
    concatMap
    attrsToList
    listToAttrs
    nameValuePair
    isAttrs
    attrNames
    ;
in
rec {

  filterMapAttrNames =
    filterFn: mapFn: attrset:
    lib.mapAttrs' (n: v: lib.nameValuePair (mapFn n) v) (lib.filterAttrs filterFn attrset);

  mapAttrNames = mapFn: attrset: filterMapAttrNames attrset (_: _: true) mapFn;

  flatMapToAttrs = fn: items: lib.mkMerge (builtins.concatMap fn items);
  # flatMapToAttrs = mapFn: items: lib.mkMerge (flatMap mapFn items);
  # flatMap = mapFn: items: lib.flatten (map mapFn items);

  filterLeaves =
    pred: attrs:
    listToAttrs (
      concatMap (
        name:
        let
          v = attrs.${name};
        in
        if isAttrs v then
          let
            v' = filterLeaves pred v;
          in
          if (builtins.length (attrsToList v')) > 0 then [ (nameValuePair name v') ] else [ ]
        else if pred name v then
          [ (nameValuePair name v) ]
        else
          [ ]
      ) (attrNames attrs)
    );
}
