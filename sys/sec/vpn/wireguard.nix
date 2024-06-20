{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.vpn.wg;
in {
  options.m.vpn.wg = {
    enable = mkEnableOption "enables wireguard";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedUDPPorts = [ 51821 ]; # Clients and peers can use the same port, see listenport
    };
    sops.secrets."work/wg/private" = {};
# prevent autostarting
    systemd.services.wireguard-wg0.wantedBy = lib.mkForce [ ];
    # Enable WireGuard
    networking.wireguard.interfaces = {
      wg0 = {
        ips = [ "192.168.4.2/32" ];
        listenPort = 51821; 
        privateKeyFile = config.sops.secrets."work/wg/private".path;
        peers = [
          {
            publicKey = "lZFtaxbeY24Z7F7yaJw4ua8vYWy8TkYMDnQVc7Cv6HU=";
            allowedIPs = [ "192.168.4.1/32" "192.168.4.2/32" "0.0.0.0/0" ];
            endpoint = "46.140.106.38:51821";
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}
