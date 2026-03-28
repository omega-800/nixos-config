{
  usr,
  sys,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionals;
  cfg = config.u.utils;
in
{
  options.u.utils.enable = mkEnableOption "essential packages";

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        which
        bc
      ]
      ++ (optionals (!usr.minimal) [
        xclip
        xbindkeys
        bind
        pdfgrep
        translate-shell
      ])
      ++ (optionals usr.extraBloat [
        # bat
        # freecad
        # vulnix
        # xdg-ninja
        # lynis
        brightnessctl
        screenkey
        cloc
        gnused
        (if usr.wmType == "x11" then simplescreenrecorder else kooha)
      ]);
    programs.nix-index.enable = usr.extraBloat;
  };
}
