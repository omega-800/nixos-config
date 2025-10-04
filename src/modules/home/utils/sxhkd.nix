{
  usr,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.utils.sxhkd;
in
{
  options.u.utils.sxhkd.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal && usr.wmType == "x11";
  };

  config = mkIf cfg.enable {
    services.sxhkd.enable = true;
  };
}
