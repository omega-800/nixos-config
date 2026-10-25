{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    mkCfg
    mkArgs
    mkUserArgs
    mkHomeModules
    mkOverlays
    allUsers
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
      hostUsers = map (user: {
        inherit user;
        args = mkUserArgs cfg user // { nixosIntegrated = true; };
        homeModules = [
          {
            nixpkgs.overlays = mkOverlays user.stable cfg.sys.system cfg.sys.genericLinux;
          }
        ] ++ mkHomeModules cfg user;
      }) (allUsers cfg);
    in
    (getPkgsInput cfg.sys.stable).lib.nixosSystem {
      inherit (cfg.sys) system;
      # FIXME: overlays
      specialArgs = (mkArgs cfg) // { inherit hostUsers; };
      modules = (mkModules cfg CONFIGS.nixosConfigurations)
      /*
        ++ (map (profile: {
          specialisation.${profile}.imports = mkModules (mkSpecCfg profile) CONFIGS.nixosConfigurations;
        }) rest)
      */
      ;
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
