{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    mkCfg mkArgs mkModules getPkgsInput mapHostConfigs CONFIGS;
in rec {

  mkHost = path: attrs:
    let cfg = mkCfg path;
    in (getPkgsInput cfg.sys.stable).lib.nixosSystem {
      inherit (cfg.sys) system;
      specialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs
        CONFIGS.nixosConfigurations; # ++ (map (service: ../../sys/srv/${service}.nix) cfg.sys.services);
    };

  mapHosts =
    # inherit (inputs.nixpkgs-unstable.lib) mapAttrs' nameValuePair;
    (mapHostConfigs CONFIGS.nixosConfigurations (path: mkHost path { }))
    # // (mapAttrs' (n: v: nameValuePair "${n}-iso" v)
    #   (mapHostConfigs dir CONFIGS.nixosConfigurations
    #     (path: mkIso path attrs)))
  ;
}
