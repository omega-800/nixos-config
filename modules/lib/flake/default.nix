{ inputs, ... }:
{
  inherit (import ./builders { inherit inputs; })
    mapHosts
    mapHomes
    mapDroids
    mapGenerics
    mapIsos
    mapDeployments
    mapApps
    mapPkgs
    mapFormatters
    mapChecks
    mapShells
    ;
  utils = import ./utils { inherit inputs; };
}
