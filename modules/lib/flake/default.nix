{ inputs, ... }: {
  inherit (import ./builders { inherit inputs; })
    mapHosts mapHomes mapDroids mapGenerics mapIsos mapDeployments mapAppsByArch
    mapPkgsByArch;
  utils = import ./utils { inherit inputs; };
}
