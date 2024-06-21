{ lib, pkgs, ... }: {
  writeCfgToScript = cfg:
      ''
      #!${pkgs.bash}
      ${
        lib.mapAttrsToList (n: v: ''${n}="${v}"'') cfg.environment.sessionVariables
      }
      '';
}
