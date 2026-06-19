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
    default = (config.u.net.enable && !usr.minimal) || usr.browser == "surf";
  };
  config = mkIf cfg.enable {
    # FIXME: libsoup eol
    # home.packages = [ (pkgs.surf.override { patches = [ ]; }) ];
  };
}
