{ pkgs, ... }:

{
  services.openvpn.servers = {
    officeVPN = { 
      config = '' config ${./vpn_work.conf} ''; 
      updateResolvConf = true;
    };
  };

  environment.systemPackages = [ pkgs.openvpn ];
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";
}
