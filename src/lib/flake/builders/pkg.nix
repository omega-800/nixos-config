{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    mkPkgs
    mapScriptsOrModules
    mkScriptBin
    PATHS
    SYSTEMS
    ;
in
{
  mapPkgs =
    let
      dir = PATHS.PACKAGES;
      inherit (inputs.nixpkgs-unstable.lib)
        hasSuffix
        ;
    in
    inputs.nixpkgs-unstable.lib.genAttrs SYSTEMS (
      arch:
      mapScriptsOrModules (
        path:
        if (hasSuffix ".sh" path) then
          (mkScriptBin arch path)
        else
          ((mkPkgs false arch false).callPackage path {
            # system = arch;
          })
      ) dir
    );
}
