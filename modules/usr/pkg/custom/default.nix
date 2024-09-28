{ lib, ... }:
with lib; {
  options.u.custom = {
    enable = mkEnableOption "enables custom pkgs";
  } // lib.my.dirs.mapFilterDir (n: { enable = mkEnableOption "enables ${n}"; })
    (n: v: true) ./.;

  imports = [ ./remote-build.nix ];
}
