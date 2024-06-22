{ lib, pkgs, ... }: {
  writeCfgToScript = cfg:
      ''
      #!/usr/bin/env bash
      ${
        "asdf"#lib.concatStrings (lib.mapAttrsToList (n: v: ''${n}="${v}"'') cfg.environment.sessionVariables)
      }
      '';

  generateInstallerList = cfg:
      lib.mkBefore [ "" ];
}
