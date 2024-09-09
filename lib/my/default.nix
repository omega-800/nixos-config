{ lib, pkgs, ... }:
let
  templ = import ./templating.nix { inherit pkgs; };
  cfg = import ./config.nix { inherit lib; };
  net = import ./networking.nix;
  def = import ./def.nix { inherit lib; };
  dirs = import ./dirs.nix { inherit lib; };
in {
  inherit templ cfg net def dirs;

  mapListToAttrs = fun: items: lib.mkMerge (builtins.concatMap fun items);
}
