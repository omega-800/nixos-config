{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    getInput
    mkCfg
    mkArgs
    mkPkgs
    mapHostConfigs
    CONFIGS
    PATHS
    ;
in
rec {

  mkDroid =
    hostname:
    let
      cfg = mkCfg hostname;
      extraSpecialArgs = mkArgs cfg;
      inherit (cfg.sys) stable system genericLinux;
    in
    (getInput "nix-on-droid" cfg.sys.stable).lib.nixOnDroidConfiguration {
      pkgs = mkPkgs stable system genericLinux;
      modules = [
        (PATHS.MODULES + /${CONFIGS.nixOnDroidConfigurations})
        {
          home-manager = {
            inherit extraSpecialArgs;
          };
        }
      ];
      inherit extraSpecialArgs;
    };

  mapDroids = mapHostConfigs CONFIGS.nixOnDroidConfigurations mkDroid;
}
