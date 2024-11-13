{
  usr,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.net.qutebrowser;
in
{
  options.u.net.qutebrowser.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable && !usr.minimal;
  };
  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      package = pkgs.nixGL pkgs.qutebrowser;
    };
  };
}
