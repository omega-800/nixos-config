{ inputs, ... }:
let
  builders = import ./builders.nix { inherit inputs; };
  templating = import ./templating.nix { inherit inputs; };
  net = import ./networking.nix;
in
with inputs.nixpkgs-stable.lib; {
  inherit (builders) mapHosts mapHomes mapModules mapPkgs mapGeneric;
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
