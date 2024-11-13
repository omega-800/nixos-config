{
  config,
  lib,
  pkgs,
  usr,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.u.sh.dash;
in
{
  options.u.sh.dash.enable = mkOption {
    type = types.bool;
    default = usr.shell.pname == "dash";
  };
  config = mkIf cfg.enable { home.packages = with pkgs; [ dash ]; };
}
