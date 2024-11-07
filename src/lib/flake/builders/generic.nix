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
    hostname:
    let
      cfg = mkCfg hostname;
    in
    (getInput "system-manager" cfg.sys.stable).lib.makeSystemConfig {
      #inherit (cfg.sys) system;
      #specialArgs = mkArgs cfg;
      modules = mkModules cfg CONFIGS.systemConfigs;
    };

  mapGenerics = mapHostConfigs CONFIGS.systemConfigs mkGeneric;
}
