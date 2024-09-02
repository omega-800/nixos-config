{ sys, usr, lib, config, pkgs, globals, ... }:
with lib;
let cfg = config.u.dev;
in {
  options.u.dev = {
    enable = mkEnableOption "enables dev packages";
    dev.enable = mkEnableOption "enables packages for development";
    bloat.enable = mkEnableOption "enables bloat";
    gui.enable = mkEnableOption "enables graphical packages";
  };

  config = mkIf cfg.enable {
    nixpkgs.config = mkIf (cfg.gui.enable && cfg.dev.enable) {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "vscode" "ciscoPacketTracer8" ];
    };
    home.packages = with pkgs;
      (if (cfg.dev.enable) then [
        jq
        gnumake
        strace
        man-pages
        man-pages-posix
        qemu
      ] else
        [ ]) ++ (if (cfg.dev.enable && cfg.bloat.enable) then [
        qmk
        perl
        ncurses
      ] else
        [ ])
      ++ (if (cfg.dev.enable && cfg.gui.enable && cfg.bloat.enable) then [
        virt-manager
        vscode
        # ciscoPacketTracer8 
      ] else
        [ ]);
    home.file = mkIf (cfg.dev.enable && cfg.bloat.enable) {
      ".config/qmk/qmk.ini".text = ''
        [user]
        qmk_home = ${globals.envVars.WORKSPACE_DIR}/qmk_firmware
      '';
    };
  };
}
