{ sys, usr, lib, config, pkgs, ... }:
with lib;
let cfg = config.u.dev;
in {
  options.u.dev = { enable = mkEnableOption "enables dev packages"; };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "vscode" "ciscoPacketTracer8" ];
    home.packages = with pkgs;
      (if !usr.minimal then [
        qmk
        perl
        strace
        jq
        gnumake
        man-pages
        man-pages-posix
      ] else
        [ ]) ++ (if usr.extraBloat then [
        qemu
        virt-manager
        ncurses
        vscode
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
      qmk_home = ${usr.homeDir}/workspace/qmk_firmware
    '';
  };
}
