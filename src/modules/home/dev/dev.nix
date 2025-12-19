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
  inherit (lib)
    mkEnableOption
    mkIf
    getName
    optionals
    mkMerge
    ;
  cfg = config.u.dev;
in
{
  options.u.dev = {
    enable = mkEnableOption "dev packages";
  };

  config = mkIf cfg.enable {
    programs = mkMerge [
      {
        go.env = {
          inherit GOBIN GOPATH;
        };
        pgcli = mkIf (builtins.elem "school" sys.profile) {
          enable = true;
          settings.main = {
            smart_completion = true;
            vi = true;
          };
        };
      }
      (
        if sys.stable then
          { }
        else
          {
            opencode.enable = usr.extraBloat;
          }
      )
    ];
    nixpkgs.config = mkIf (builtins.elem "school" sys.profile) {
      allowUnfreePredicate = pkg: builtins.elem (getName pkg) [ "ciscoPacketTracer8" ];
      permittedInsecurePackages = [ "ciscoPacketTracer8-8.2.2" ];
    };
    home.packages =
      with pkgs;
      [ jq ]
      ++ (optionals (!usr.minimal) [
        pastel
        man-pages
        man-pages-posix
        # wikiman
      ])
      ++ (optionals usr.extraBloat [
        perl
        strace
        yq-go
        gnumake
        qemu
        virt-manager
        slides
      ])
      ++ (optionals (builtins.elem "school" sys.profile) [
        dbeaver-bin
        rfc
        # cisco is such a pain in the ass
        # https://www.netacad.com/resources/lab-downloads?courseLang=en-US
        # nix-prefetch-url --type sha256 file:///path/to/CiscoPacketTracer822_amd64_signed.deb
        # sudo firejail --noprofile --net=none packettracer8
        # sudo ip netns add offline-ns && sudo ip netns exec offline-ns packettracer8
        # (symlinkJoin (
        #   let
        #     name = "packettracer8";
        #   in
        #   {
        #     inherit name;
        #     paths = [
        #       (writeShellScriptBin name "firejail --net=none ${ciscoPacketTracer8}/bin/${name}")
              ciscoPacketTracer8
        #     ];
        #   }
        # ))
      ]);
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
  };
}
