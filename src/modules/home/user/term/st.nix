{
  lib,
  pkgs,
  inputs,
  config,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.user.st;
in
{
  options.u.user.st.enable = mkOption {
    type = types.bool;
    default = config.u.user.enable && !usr.minimal && (usr.term == "st");
  };
  config = mkIf cfg.enable { home.packages = [ pkgs.omega-st ]; };
}
