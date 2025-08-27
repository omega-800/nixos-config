{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.m.net.vpn.openvpn;
in
{
  options.m.net.vpn.openvpn.enable = mkEnableOption "openvpn";

  config = mkIf cfg.enable {
    /*
      services.openvpn.servers = {
        officeVPN = {
          config = '' config ${./vpn_work.conf} '';
          updateResolvConf = true;
        };
      };
    */

    environment = {
      systemPackages = [ pkgs.openvpn ];
      etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
    };
  };
}
