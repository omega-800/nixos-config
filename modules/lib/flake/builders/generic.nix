{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    getInput
    mkCfg
    mkArgs
    mkModules
    mapHostConfigs
    CONFIGS
    ;
in
rec {
  mkGeneric =
    path: attrs:
    let
      cfg = mkCfg path;
    in
    (getInput "system-manager" cfg.sys.stable).lib.makeSystemConfig {
      #inherit (cfg.sys) system;
      #specialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs CONFIGS.systemConfigs;
    };

  mapGenerics = mapHostConfigs CONFIGS.systemConfigs (path: mkGeneric path { });
}
