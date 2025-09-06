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

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [ "discord" ];
    home.packages = mkIf (usr.extraBloat && sys.profile == "pers") [ pkgs.discord ];
  };
}
