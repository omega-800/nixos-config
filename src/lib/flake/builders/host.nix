{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    mkCfg
    mkArgs
    mkModules
    getPkgsInput
    mapHostConfigs
    CONFIGS
    ;
in
rec {

  mkHost =
    hostname:
    let
      cfg = mkCfg hostname;
    in
    (getPkgsInput cfg.sys.stable).lib.nixosSystem {
      inherit (cfg.sys) system;
      specialArgs = mkArgs cfg;
      modules = mkModules cfg CONFIGS.nixosConfigurations; # ++ (map (service: ../../sys/srv/${service}.nix) cfg.sys.services);
    };

  mapHosts = (mapHostConfigs CONFIGS.nixosConfigurations mkHost)
  # // (mapAttrs' (n: v: nameValuePair "${n}-iso" v)
  #   (mapHostConfigs dir CONFIGS.nixosConfigurations
  #     (path: mkIso path attrs)))
  ;
}
