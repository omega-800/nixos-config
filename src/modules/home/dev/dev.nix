{
  sys,
  usr,
  lib,
  config,
  pkgs,
  globals,
  ...
}:
with globals.envVars;
let
  inherit (lib) mkEnableOption mkIf getName optionals;
  cfg = config.u.dev;
in
{
  options.u.dev.enable = mkEnableOption "dev packages";

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [ "ciscoPacketTracer8" ];
    programs.pgcli = mkIf (sys.profile == "school") {
      enable = true;
      settings.main = {
        smart_completion = true;
        vi = true;
      };
    };
    home.packages =
      with pkgs;
      [ jq ]
      ++ (
        optionals (!usr.minimal)
          [
            pastel
            yq-go
            qmk
            perl
            strace
            gnumake
            man-pages
            man-pages-posix
            # wikiman
          ]
      )
      ++ (
        optionals usr.extraBloat
          [
            qemu
            virt-manager
            ncurses
          ]
      )
      ++ (
        optionals (usr.extraBloat && sys.profile == "pers")
          [
            # ciscoPacketTracer8
          ]
      )
      ++ (optionals (sys.profile == "school") [ dbeaver-bin ])
      ;
    home.file = {
      ".config/qmk/qmk.ini".text = ''
        [user]
        qmk_home = ${WORKSPACE_DIR}/qmk_firmware
      '';
      ".config/python/pythonrc".text = # python
        ''
          def is_vanilla() -> bool:
              import sys
              return not hasattr(__builtins__, '__IPYTHON__') and 'bpython' not in sys.argv[0]

          def setup_history():
              import os
              import atexit
              import readline
              from pathlib import Path

              if state_home := os.environ.get('XDG_STATE_HOME'):
                  state_home = Path(state_home)
              else:
                  state_home = Path.home() / '.local' / 'state'

              history: Path = state_home / 'python_history'

              readline.read_history_file(str(history))
              atexit.register(readline.write_history_file, str(history))

          if is_vanilla():
              setup_history()
        '';
      ".config/npm/npmrc".text = ''
        prefix=${NPM_PREFIX}
        cache=${NPM_CACHE}
        init=${NPM_INIT_MODULE}
        tmp=${NPM_TMP}
      '';
    };
    programs.go = {
      goBin = GOBIN;
      goPath = GOPATH;
    };
  };
}
