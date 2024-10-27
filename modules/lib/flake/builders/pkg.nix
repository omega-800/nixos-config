{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    mkPkgs mapModules PATHS;
in {
  mapPkgsByArch = architectures:
    let dir = PATHS.MODULES + /pkgs;
    in inputs.nixpkgs-unstable.lib.genAttrs architectures (arch:
      mapModules (path:
        (mkPkgs false arch false).callPackage path {
          # system = arch;
        }) dir);
}
