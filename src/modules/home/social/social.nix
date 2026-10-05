{
  sys,
  usr,
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    optionals
    getName
    mkIf
    ;
  cfg = config.u.social;
in
{
  options.u.social.enable = mkEnableOption "social packages";
}
