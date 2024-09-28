{ pkgs, lib, ... }: {
  # hacky hack hack for badly written bash scripts
  bashScriptToNix = n: p:
    (pkgs.writeShellScript n
      (builtins.replaceStrings [ "#!/bin/bash" ] [ "#!${pkgs.bash}/bin/bash" ]
        (builtins.readFile p)));
}
