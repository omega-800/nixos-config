{ lib, pkgs, ... }: {
  writeCfgToScript = cfg:
      ''
      #!/usr/bin/env bash
      ${
        lib.concatStrings (lib.mapAttrsToList (n: v: ''${n}="${v}"'') cfg.environment.sessionVariables)
      }
      '';
}
