{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    getInput mkCfg mkArgs mkPkgs mapHostConfigs CONFIGS PATHS;
in rec {

  mkDroid = path: attrs:
    let
      cfg = mkCfg path;
      extraSpecialArgs = mkArgs cfg;
    in (getInput "nix-on-droid" cfg.sys.stable).lib.nixOnDroidConfiguration {
      pkgs = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      modules = [
        (PATHS.MODULES + /droid)
        { home-manager = { inherit extraSpecialArgs; }; }
      ];
      inherit extraSpecialArgs;
    };

  mapDroids =
    mapHostConfigs CONFIGS.nixOnDroidConfigurations (path: mkDroid path { });
}
