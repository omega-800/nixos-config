{
  usr,
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
      ])
      ++ (optionals usr.extraBloat [
        brightnessctl
        bat
        freecad
        vulnix
        screenkey
        cloc
        gnused
        xdg-ninja
        translate-shell
        lynis
        (if sys.wmType == "x11" then simplescreenrecorder else kooha)
      ]);
    programs.nix-index.enable = usr.extraBloat;
  };
}
