{ lib, ... }:
let
  inherit (lib) mkEnableOption omega;
in
{
  options.u.custom = {
    enable = mkEnableOption "custom pkgs";
  } // omega.dirs.mapFilterDir (n: { enable = mkEnableOption n; }) (_: _: true) ./.;
}
