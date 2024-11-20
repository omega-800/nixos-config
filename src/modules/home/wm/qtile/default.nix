{
  config,
  usr,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.u.wm.qtile;
  dwm_stats = pkgs.writeShellScript "dwm_stats" ./dwm_stats.sh;
  inherit (lib)
    mkOption
    mkIf
    types
    mkDefault
    ;
in
{
  options.u.wm.qtile.enable = mkOption {
    type = types.bool;
    default = usr.wm == "qtile";
  };
  config = mkIf cfg.enable {
    u.wm.x11.initExtra = ''
      qtile start
    '';
  };
}
