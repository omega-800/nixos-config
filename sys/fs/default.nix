{ lib, sys, ... }:
with lib; {
  options.m.fs.enable = mkEnableOption "enables filesystem features";
  imports = [ ./automount.nix ./dirs.nix ./thunar.nix ./type/${sys.fs}.nix ];
}
