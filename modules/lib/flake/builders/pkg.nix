{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    mkPkgs
    mapModules
    PATHS
    SYSTEMS
    ;
in
{
  mapPkgs =
    let
      dir = PATHS.MODULES + /pkgs;
    in
    inputs.nixpkgs-unstable.lib.genAttrs SYSTEMS (
      arch:
      mapModules (
        path:
        (mkPkgs false arch false).callPackage path {
          # system = arch;
        }
      ) dir
    );
}
