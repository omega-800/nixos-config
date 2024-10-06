{ inputs, ... }:
let builders = import ./builders { inherit inputs; };
in with inputs.nixpkgs-unstable; {
  inherit (builders) mapHosts mapHomes mapModulesByArch mapModules mapPkgs mapAppsByArch;
}
