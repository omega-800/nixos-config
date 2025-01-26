{ pkgs, ... }:
rec {
  keyG =
    k: name: list:
    let
      desc = "+${name}";
    in
    [ (key "n" k desc desc) ] ++ (map (i: i // { key = "${k}${i.key}"; }) list);
  key = mode: key: action: desc: {
    inherit mode key action;
    options = {
      inherit desc;
    };
  };
  keyS =
    mode: key: action: desc:
    (key mode key action desc)
    // {
      options = {
        inherit desc;
        silent = true;
      };
    };
}
