{ lib, ... }:
let
  inherit (import ../flake/utils/vars.nix) PATHS CONFIGS;
in
rec {
  # just don't try to get any attrs which depend on pkgs or you'll encounter that awesome infinite recursion everybody is talking about
  getCfgAttr =
    hostname: type: name:
    (lib.evalModules {
      modules = [
        {
          config._module.args = {
            inherit PATHS CONFIGS;
          };
        }
        (PATHS.PROFILES + /default/options.nix)
        (PATHS.NODES + /${hostname}/${CONFIGS.omega}.nix)
      ];
    }).config.c.${type}.${name};

  #TODO: flake.checks.isOnlyOrchestrator && flake.checks.hasOrchestrator
  getOrchestrator = builtins.elemAt (filterHosts (c: builtins.elem "master" c.sys.flavors)) 0;

  filterHosts = fn: map (c: c.sys.hostname) (filterCfgs fn);

  filterCfgsByVal =
    type: name: val:
    filterCfgs (c: c.${type}.${name} == val);

  filterCfgs = filterFn: builtins.filter filterFn allCfgs;

  getCfgAttrOfAllHosts = type: name: map (hostname: (getCfgAttr hostname type name)) allHosts;

  allCfgs = mapHosts (
    n: v:
    (lib.evalModules {
      modules = [
        (PATHS.PROFILES + /default/options.nix)
        (PATHS.NODES + /${n}/${CONFIGS.omega}.nix)
      ];
    }).config.c
  );

  allHosts = mapHosts (n: v: n);

  mapHosts =
    fn:
    lib.mapAttrsToList fn (
      lib.filterAttrs (
        n: v: v == "directory" && builtins.pathExists (PATHS.NODES + /${n}/${CONFIGS.omega}.nix)
      ) (builtins.readDir PATHS.NODES)
    );

}
