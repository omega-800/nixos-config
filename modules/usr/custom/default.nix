{ lib, ... }:
with lib;
{
  options.u.custom = {
    enable = mkEnableOption "enables custom pkgs";
  } // lib.omega.dirs.mapFilterDir (n: { enable = mkEnableOption "enables ${n}"; }) (n: v: true) ./.;
}
