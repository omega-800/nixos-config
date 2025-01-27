{ pkgs, ... }:
rec {
  keyG =
    k: name: list:
    let
      desc = "+${name}";
    in
    [ (key "n" k desc desc) ] ++ (map (i: i // { key = "${k}${i.key}"; }) list);
  key = mode: k: action: desc: {
    inherit mode action;
    key = k;
    options = {
      inherit desc;
    };
  };
  keyS =
    mode: k: action: desc:
    (key mode k action desc)
    // {
      options = {
        inherit desc;
        silent = true;
      };
    };
}
