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
  cfg = config.u.net.surf;
in
{
  options.u.net.surf.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable && !usr.minimal;
  };
  config = mkIf cfg.enable {
    home.packages = [ (pkgs.surf.override { patches = [ ]; }) ];
  };
}
