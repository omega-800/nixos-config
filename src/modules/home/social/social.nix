{
  sys,
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    getName
    ;
  cfg = config.u.social;
in
{
  options.u.social.enable = mkEnableOption "social packages";

  config = mkIf (cfg.enable && usr.extraBloat && sys.profile == "pers") {
    nixpkgs.config.allowUnfreePredicate = p: builtins.elem (getName p) [ "discord" ];
    home.packages = [ pkgs.discord ];
  };
}
