{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.m.net.vpn.forti;
in
{
  options.m.net.vpn.forti.enable = mkEnableOption "openfortivpn";

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.openfortivpn ];
  };
}
