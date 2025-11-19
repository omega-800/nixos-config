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

  config = mkIf (cfg.enable && usr.extraBloat) {
    home.packages =
      with pkgs;
      [
        signal-desktop
      ]
      ++ (optionals (sys.profile == "school") [ pkgs.teams-for-linux ]);

  };
}
