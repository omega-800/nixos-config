{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    importModule
    mapScriptsOrModules
    mkScriptBin
    PATHS
    SYSTEMS
    ;
in
{
  mapApps =
    let
      dir = PATHS.APPS;
      inherit (inputs.nixpkgs-unstable.lib)
        hasSuffix
        genAttrs
        ;
    in
    genAttrs SYSTEMS (
      arch:
      mapScriptsOrModules (
        path:
        if (hasSuffix ".sh" path) then
          {
            type = "app";
            program = mkScriptBin arch path;
          }
        else
          (importModule path arch { })
      ) dir
    );
}
