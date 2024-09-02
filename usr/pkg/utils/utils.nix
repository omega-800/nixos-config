{ usr, lib, config, pkgs, ... }:
with lib;
let cfg = config.u.utils;
in {
  options.u.utils = {
    enable = mkEnableOption "enables essential packages";
    bloat.enable = mkEnableOption "enables bloat packages";
    qol.enable = mkEnableOption "enables quality of life packages";
    gui.enable = mkEnableOption "enables graphical packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [ iproute2 iputils curl ] ++ (if cfg.qol.enable then [
        ripgrep
        wget
        which
        less
        bc
        htop-vim
        thefuck
        translate-shell
      ] else
        [ htop ]) ++ (if cfg.gui.enable then [
        bc
        xclip
        xbindkeys
        brightnessctl
      ] else
        [ ]) ++ (if cfg.bloat.enable then [
        stow
        bind
        gnused
        xdg-ninja
      ] else [ ])
      ++ (if (cfg.bloat.enable && cfg.gui.enable) then [
        screenkey
        freecad
      ] else [ ])
      ++ (if (cfg.dev.enable) then [
        cloc
        vulnix
        lynis
      ] else [ ]);
  };
}
