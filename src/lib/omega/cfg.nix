{ lib, sys, ... }:
let
  inherit (import ../flake/utils/vars.nix) PATHS CONFIGS;
in
rec {
  mkCfgModules = hostname: [
    PATHS.M_OMEGA
    (PATHS.NODES + /${hostname}/${CONFIGS.omega}.nix)
    {
      config = {
        _module.args = {
          globals = {
            inherit PATHS CONFIGS;
          };
          inherit PATHS CONFIGS;
        };
        c.net.hostname = hostname;
      };
    }
  ];
  # just don't try to get any attrs which depend on pkgs or you'll encounter that awesome infinite recursion everybody is talking about
  getCfgAttr =
    hostname: type: name:
    (lib.evalModules {
      modules = mkCfgModules hostname;
    }).config.c.${type}.${name};

  mkSpecialisation =
    type: config:
    if (builtins.elem type sys.profile) then
      (
        if ((builtins.elemAt sys.profile 0) == type) then
          config
        else
          {
            specialisation.${type}.configuration = config;
          }
      )
    else
      { };

  #TODO: flake.checks.isOnlyOrchestrator && flake.checks.hasOrchestrator
  getOrchestrator = builtins.elemAt (filterHosts (c: builtins.elem "master" c.sys.flavors)) 0;

  filterHosts = fn: map (c: c.net.hostname) (filterCfgs fn);

  cfgsOfFlavor = flavor: filterCfgs (c: builtins.elem flavor c.sys.flavors);

  filterCfgsByVal =
    type: name: val:
    filterCfgs (c: c.${type}.${name} == val);

  filterCfgs = filterFn: builtins.filter filterFn allCfgs;

  getCfgAttrOfAllHosts = type: name: map (hostname: (getCfgAttr hostname type name)) allHosts;

  getCfgAttrOfMatchingHosts =
    fn: type: name:
    map (c: c.${type}.${name}) (filterCfgs fn);

  allCfgs = mapHosts (
    n: _:
    (lib.evalModules {
      modules = mkCfgModules n;
    }).config.c
  );

  allHosts = mapHosts (n: _: n);

  mapHosts =
    fn:
    lib.mapAttrsToList fn (
      lib.filterAttrs (
        # TODO: merge with flake-lib modules.nix
        n: v:
        v == "directory"
        && !(lib.hasPrefix "_" n)
        && builtins.pathExists (PATHS.NODES + /${n}/${CONFIGS.omega}.nix)
      ) (builtins.readDir PATHS.NODES)
    );
}
