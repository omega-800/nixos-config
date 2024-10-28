{ lib, ... }:
let
  hostsPath = ../../hosts;
in
rec {
  # just don't try to get any attrs which depend on pkgs or you'll encounter that awesome infinite recursion everybody is talking about
  getCfgAttr =
    path: type: name:
    (lib.evalModules {
      modules = [
        ../../profiles/default/options.nix
        (import "${path}/config.nix")
      ];
    }).config.c.${type}.${name};

  #TODO: flake.checks.isOnlyOrchestrator && flake.checks.hasOrchestrator
  getOrchestrator = builtins.elemAt (filterHosts (c: builtins.elem "master" c.sys.flavors)) 0;

  filterHosts = fn: map (c: c.sys.hostname) (filterCfgs fn);

  filterCfgsByVal =
    type: name: val:
    filterCfgs (c: c.${type}.${name} == val);

  filterCfgs = filterFn: builtins.filter filterFn allCfgs;

  getCfgAttrOfAllHosts =
    type: name: map (hostname: (getCfgAttr "${hostsPath}/${hostname}" type name)) allHosts;

  allCfgs =
    lib.mapAttrsToList
      (
        n: v:
        (lib.evalModules {
          modules = [
            ../../profiles/default/options.nix
            (import "${hostsPath}/${n}/config.nix")
          ];
        }).config.c
      )
      (
        lib.filterAttrs (n: v: v == "directory" && builtins.pathExists "${hostsPath}/${n}/config.nix") (
          builtins.readDir hostsPath
        )
      );

  allHosts = lib.mapAttrsToList (n: v: n) (
    lib.filterAttrs (n: v: v == "directory" && builtins.pathExists "${hostsPath}/${n}/config.nix") (
      builtins.readDir hostsPath
    )
  );
}
