{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    mkCfg
    mkArgs
    mkModules
    mkPkgs
    getHomeMgrInput
    mapHostConfigs
    CONFIGS
    ;
in
rec {

  mkHome =
    hostname:
    let
      cfg = mkCfg hostname;
      inherit (cfg.sys) stable system genericLinux;
    in
    # ok so calling mkArgs does not work because it causes infinite recursion of usr attr set?? bc mkConfig's usr is being passed to mkArgs as well as writeCfgToScript???? but usr isn't even used in writeCfgToScript????????? i am brain hurty
    #extraSpecialArgs = mkMerge [(mkArgs cfg) { genericLinuxSystemInstaller = writeCfgToScript cfg; } ];
    (getHomeMgrInput stable).lib.homeManagerConfiguration {
      pkgs = mkPkgs stable system genericLinux;
      extraSpecialArgs = mkArgs cfg;
      modules = mkModules cfg CONFIGS.homeConfigurations;
    };

  mapHomes = mapHostConfigs CONFIGS.homeConfigurations mkHome;
}
