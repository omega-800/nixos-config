{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.vpn.openvpn;
in {
  options.m.vpn.openvpn = {
    enable = mkEnableOption "enables openvpn";
  };

  config = mkIf cfg.enable {
  services.openvpn.servers = {
    officeVPN = { 
      config = '' config ${./vpn_work.conf} ''; 
      updateResolvConf = true;
    };
  };

  environment.systemPackages = [ pkgs.openvpn ];
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
};
}
