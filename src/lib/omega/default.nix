{ lib, pkgs, ... }:
let
  dirs = import ./dirs.nix { inherit lib; };
in
(dirs.mapFilterDir (v: import v { inherit lib pkgs; }) (
  n: v: (v == "regular" && n != "default.nix")
) ./.)
// { }
