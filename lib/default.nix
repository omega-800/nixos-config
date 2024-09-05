{ inputs, pkgs, lib, ... }:
let
  builders = import ./builders.nix { inherit inputs pkgs lib; };
  templating = import ./templating.nix { inherit inputs pkgs lib; };
  net = import ./networking.nix;
in
{
  inherit (builders) mapHosts mapHomes mapModules mapPkgs;
  inherit (templating) parseYaml templateFile;
  mapListToAttrs = fun: items: lib.mkMerge (builtins.concatMap fun items);
  mkHighDefault = val: lib.mkOverride 900 val;
  mkHigherDefault = val: lib.mkOverride 800 val;
  mkHighererDefault = val: lib.mkOverride 700 val;
  mkLowMid = val: lib.mkOverride 600 val;
  mkMid = val: lib.mkOverride 500 val;
  mkHighMid = val: lib.mkOverride 400 val;
  mkHighererMid = val: lib.mkOverride 300 val;
}
