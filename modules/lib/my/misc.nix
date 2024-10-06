{ pkgs, lib, ... }: {
  # hacky hack hack for badly written bash scripts
  bashScriptToNix = n: p:
    (pkgs.writeShellScript n
      (builtins.replaceStrings [ "#!/bin/bash" ] [ "#!${pkgs.bash}/bin/bash" ]
        (builtins.readFile p)));

  poolsContainFs = fsType: diskoCfg:
    diskoCfg.pools != null && (builtins.elem fsType
      (lib.mapAttrsToList (n: v: v.type) diskoCfg.pools));
}
