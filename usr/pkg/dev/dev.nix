{ sys, usr, lib, config, pkgs, globals, ... }:
with lib;
with globals.envVars;
let cfg = config.u.dev;
in {
  options.u.dev = { enable = mkEnableOption "enables dev packages"; };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "ciscoPacketTracer8" ];
    home.packages = with pkgs;
      [ jq ] ++ (if !usr.minimal then [
        qmk
        perl
        strace
        gnumake
        man-pages
        man-pages-posix
      ] else
        [ ]) ++ (if usr.extraBloat then [
        qemu
        virt-manager
        ncurses
        # TODO: put this in a nix-shell
        # nvm
        # npm
        # node
        # ansible-core
        # python3
      ] else
        [ ]) ++ (if usr.extraBloat && sys.profile == "pers" then
        [
          # ciscoPacketTracer8 
        ]
      else
        [ ]);
    home.file.".config/qmk/qmk.ini".text = ''
      [user]
      qmk_home = ${WORKSPACE_DIR}/qmk_firmware
    '';
    programs.go = {
      goBin = GOBIN;
      goPath = GOPATH;
    };
  };
}
