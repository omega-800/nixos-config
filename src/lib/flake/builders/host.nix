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
  inherit (inputs.nixpkgs-unstable.lib) mkMerge sublist;
  mkHost =
    hostname:
    let
      cfg = mkCfg hostname;
      defProfile = builtins.elemAt cfg.sys.profile 0;
      rest = sublist 1 (builtins.length cfg.sys.profile) cfg.sys.profile;
      mkSpecCfg = profile: mkMerge [cfg { sys = { inherit profile; }; }];
    in
    (getPkgsInput cfg.sys.stable).lib.nixosSystem {
      inherit (cfg.sys) system;
      # FIXME: overlays
      specialArgs = mkArgs cfg;
      modules =
        (mkModules (mkSpecCfg defProfile) CONFIGS.nixosConfigurations)
        ++ (map (profile: {
          specialisation.${profile}.imports = mkModules (mkSpecCfg profile) CONFIGS.nixosConfigurations;
        }) rest);
      # mkModules cfg CONFIGS.nixosConfigurations; # ++ (map (service: ../../sys/srv/${service}.nix) cfg.sys.services);
    };
in
{
  inherit mkHost;

  mapHosts = mapHostConfigs CONFIGS.nixosConfigurations mkHost
  # // (mapAttrs' (n: v: nameValuePair "${n}-iso" v)
  #   (mapHostConfigs dir CONFIGS.nixosConfigurations
  #     (path: mkIso path attrs)))
  ;
}
