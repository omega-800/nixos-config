{
  config,
  pkgs,
  usr,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.net.servo;
in
{
  options.u.net.servo.enable = mkOption {
    type = types.bool;
    default = (config.u.net.enable && usr.extraBloat) || usr.browser == "servo";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.servo ];
  };
}
