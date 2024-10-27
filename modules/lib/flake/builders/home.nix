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
    path: attrs:
    let
      cfg = mkCfg path;
    in
    # ok so calling mkArgs does not work because it causes infinite recursion of usr attr set?? bc mkConfig's usr is being passed to mkArgs as well as writeCfgToScript???? but usr isn't even used in writeCfgToScript????????? i am brain hurty
    #extraSpecialArgs = mkMerge [(mkArgs cfg) { genericLinuxSystemInstaller = writeCfgToScript cfg; } ];
    (getHomeMgrInput cfg.sys.stable).lib.homeManagerConfiguration {
      pkgs = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      extraSpecialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs CONFIGS.homeConfigurations;
    };

  mapHomes = mapHostConfigs CONFIGS.homeConfigurations (path: mkHome path { });
}
