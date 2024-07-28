{ inputs, pkgs, lib, ... }:
let
  builders = import ./builders.nix { inherit inputs pkgs lib; };
  templating = import ./templating.nix { inherit inputs pkgs lib; };
in
{
  inherit (builders) mapHosts mapHomes mapModules mapPkgs;
  inherit (templating) parseYaml templateFile;
}
