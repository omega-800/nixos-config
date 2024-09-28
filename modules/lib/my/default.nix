{ lib, pkgs, ... }:
let
  templ = import ./templ.nix { inherit pkgs; };
  cfg = import ./cfg.nix { inherit lib; };
  net = import ./net.nix;
  def = import ./def.nix { inherit lib; };
  dirs = import ./dirs.nix { inherit lib; };
  attrs = import ./attrs.nix { inherit lib; };
in
{
  inherit templ cfg net def dirs attrs;

  mapListToAttrs = fun: items: lib.mkMerge (builtins.concatMap fun items);
}
