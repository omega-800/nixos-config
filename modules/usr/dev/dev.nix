{
  sys,
  usr,
  lib,
  config,
  pkgs,
  globals,
  ...
}:
with lib;
with globals.envVars;
let
  cfg = config.u.dev;
in
{
  options.u.dev = {
    enable = mkEnableOption "enables dev packages";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "ciscoPacketTracer8" ];
    home.packages =
      with pkgs;
      [ jq ]
      ++ (
        if !usr.minimal then
          [
            qmk
            perl
            strace
            gnumake
            man-pages
            man-pages-posix
          ]
        else
          [ ]
      )
      ++ (
        if usr.extraBloat then
          [
            qemu
            virt-manager
            ncurses
            # TODO: put this in a nix-shell
            # nvm
            # npm
            # node
            # ansible-core
            # python3
          ]
        else
          [ ]
      )
      ++ (
        if usr.extraBloat && sys.profile == "pers" then
          [
            # ciscoPacketTracer8 
          ]
        else
          [ ]
      );
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
