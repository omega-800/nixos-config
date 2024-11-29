{ pkgs, lib, ... }:
let
  recurse =
    path: attrs:
    let
      isDerivation = builtins.tryEval (lib.isDerivation attrs);
    in
    if !isDerivation.success then
      "<failure>"
    else if isDerivation.value then
      path
    #attrs.name or "<unknown name>"
    else if lib.isAttrs attrs && (attrs.recurseForDerivations or false) then
      lib.mapAttrs (n: recurse (path ++ [ n ])) attrs
    else
      null;
in
lib.mapAttrs (n: recurse [ n ]) pkgs
