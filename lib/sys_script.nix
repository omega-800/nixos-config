{ lib, pkgs, ... }: {
  writeCfgToScript = cfg:
      ''
      #!/usr/bin/env bash
      ${
        "echo no"#lib.concatStrings (lib.mapAttrsToList (n: v: ''${n}="${v}"'') cfg.environment.sessionVariables)
      }
      '';

  generateInstallerList = cfg:
      lib.mkBefore [ "" ];
}
