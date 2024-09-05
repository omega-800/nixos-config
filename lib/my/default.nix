{ lib, pkgs, ... }:
let
  templating = import ./templating.nix { inherit pkgs; };
  net = import ./networking.nix;
in
{
  inherit (templating) parseYaml templateFile;
  mapListToAttrs = fun: items: lib.mkMerge (builtins.concatMap fun items);
  mkHighDefault = val: lib.mkOverride 900 val;
  mkHigherDefault = val: lib.mkOverride 800 val;
  mkHighererDefault = val: lib.mkOverride 700 val;
  mkLowMid = val: lib.mkOverride 600 val;
  mkMid = val: lib.mkOverride 500 val;
  mkHighMid = val: lib.mkOverride 400 val;
  mkHighererMid = val: lib.mkOverride 300 val;
  # hacky hack hack for badly written bash scripts
  bashScriptToNix = n: p:
    (pkgs.writeShellScript n
      (builtins.replaceStrings [ "#!/bin/bash" ] [ "#!${pkgs.bash}/bin/bash" ]
        (builtins.readFile p)));

}
