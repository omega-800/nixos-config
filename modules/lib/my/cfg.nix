{ lib, ... }:
let hostsPath = ../../hosts;
in rec {
  # just don't try to get any attrs which depend on pkgs or you'll encounter that awesome infinite recursion everybody is talking about
  getCfgAttr = path: type: name:
    (lib.evalModules {
      modules =
        [ ../../profiles/default/options.nix (import "${path}/config.nix") ];
    }).config.c.${type}.${name};

  #TODO: flake.checks.isOnlyOrchestrator && flake.checks.hasOrchestrator
  getOrchestrator = builtins.elemAt (getHostsByCfgVal "sys" "main" true) 0;

  getHostsByCfgVal = type: name: val:
    map (c: c.sys.hostname) (filterCfgsByVal type name val);

  filterCfgsByVal = type: name: val:
    builtins.filter (c: c.${type}.${name} == val) allCfgs;

  filterCfgs = filterFn: builtins.filter filterFn allCfgs;

  getCfgAttrOfAllHosts = type: name:
    map (hostname: (getCfgAttr "${hostsPath}/${hostname}" type name)) allCfgs;

  allCfgs = lib.mapAttrsToList (n: v: n) (lib.filterAttrs (n: v:
    v == "directory" && builtins.pathExists "${hostsPath}/${n}/config.nix")
    (builtins.readDir hostsPath));
}
