{ lib, config, pkgs, usr, ... }:
with lib;
let cfg = config.m.vpn.wg;
in {
  options.m.vpn.wg = { enable = mkEnableOption "enables wireguard"; };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedUDPPorts = [
        51821
        51420
      ]; # Clients and peers can use the same port, see listenport
    };

    # yea so this doesn't work
    # sops.secrets."wg" = { };
    #
    # networking.wireguard.interfaces =
    #   lib.my.parseYaml config.sops.secrets."wg".path;
    #
    # systemd.services = lib.concatMapAttrs
    #   (name: value: { "wireguard-${cfg.name}".wantedBy = lib.mkForce [ ]; })
    #   (lib.my.parseYaml config.sops.secrets."wg".path);

    sops.secrets."wg/work/privateKey" = { };
    sops.secrets."wg/pfsense/privateKey" = { };

    # prevent autostarting
    systemd.services = {
      wireguard-work.wantedBy = lib.mkForce [ ];
      wg-quick-work.wantedBy = lib.mkForce [ ];
      wireguard-pfsense.wantedBy = lib.mkForce [ ];
      wg-quick-pfsense.wantedBy = lib.mkForce [ ];
    };
    # Enable WireGuard
    networking.wg-quick.interfaces = {
      pfsense = {
        #ips = [ "172.16.16.2/24" ];
        listenPort = 51420;
        privateKeyFile = config.sops.secrets."wg/pfsense/privateKey".path;
        peers = [{
          publicKey = "dR9PUbSvpilRLiYcIDJp11O7IG94GStOa1XhBspzGC4=";
          allowedIPs = [ "172.16.16.0/24" "10.0.1.0/24" "0.0.0.0/0" ];
          endpoint = "10.0.0.10:51420";
          persistentKeepalive = 25;
        }];
      };
      work = {
        #ips = [ "192.168.4.2/32" ];
        listenPort = 51821;
        privateKeyFile = config.sops.secrets."wg/work/privateKey".path;
        peers = [{
          publicKey = "lZFtaxbeY24Z7F7yaJw4ua8vYWy8TkYMDnQVc7Cv6HU=";
          allowedIPs = [ "192.168.4.1/32" "192.168.4.2/32" "0.0.0.0/0" ];
          endpoint = "46.140.106.38:51821";
          persistentKeepalive = 25;
        }];
      };
    };
  };
}
