{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.u.utils;
in
{
  options.u.utils.enable = mkEnableOption "essential packages";

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        iproute2
        iputils
        curl
        wget
        which
        bc
      ]
      ++ (
        if !usr.minimal then
          [
            stow
            xclip
            xbindkeys
            brightnessctl
            bind
          ]
        else
          [ ]
      )
      ++ (
        if usr.extraBloat then
          [
            bat
            freecad
            vulnix
            screenkey
            cloc
            gnused
            xdg-ninja
            translate-shell
            lynis
          ]
        else
          [ ]
      );
  };
}
