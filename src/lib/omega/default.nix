{ lib, ... }@inputs:
let
  dirs = import ./dirs.nix { inherit lib; };
in
(dirs.mapFilterDir (v: import v inputs) (n: v: (v == "regular" && n != "default.nix")) ./.) // { }
