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

  config = mkIf (cfg.enable && usr.extraBloat) {
    nixpkgs.config.allowUnfreePredicate = p: builtins.elem (getName p) [ "discord" ];
    home.packages = with pkgs; [ discord signal-desktop ];
  };
}
