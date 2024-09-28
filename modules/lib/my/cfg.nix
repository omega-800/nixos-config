{ lib, ... }: rec {
  # just don't try to get any attrs which depend on pkgs or you'll encounter that awesome infinite recursion everybody is talking about
  getCfgAttr = path: type: name:
    (lib.evalModules {
      modules =
        [ ../../profiles/default/options.nix (import "${path}/config.nix") ];
    }).config.c.${type}.${name};

  getCfgAttrOfAllHosts = type: name:
    let hostsPath = ../../hosts;
    in map (hostname: (getCfgAttr "${hostsPath}/${hostname}" type name))
    (lib.mapAttrsToList (n: v: n) (lib.filterAttrs (n: v:
      v == "directory" && builtins.pathExists "${hostsPath}/${n}/config.nix")
      (builtins.readDir hostsPath)));
}
