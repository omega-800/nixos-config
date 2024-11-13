{ inputs }:
{
  inherit (import ./modules.nix { inherit inputs; })
    mapModules
    importModule
    mapModulesByArch
    mapHostConfigs
    hasHostConfig
    ;
  inherit (import ./pkgs.nix { inherit inputs; })
    mkOverlays
    getInput
    mkInputs
    getPkgsInput
    getHomeMgrInput
    mkPkgs
    ;
  inherit (import ./util.nix { inherit inputs; })
    mkCfg
    mkModules
    mkLib
    mkArgs
    ;
  inherit (import ./vars.nix) CONFIGS PATHS SYSTEMS;
}
