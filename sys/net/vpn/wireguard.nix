{ lib, config, pkgs, usr, ... }:
with lib;
let
  cfg = config.m.net.vpn.wg;
  ifaces = [
    {
      name = "pfsense";
      port = 51820;
      ips = [ "172.16.16.2/24" ];
      host = "10.0.0.10";
      peer = {
        publicKey = "dR9PUbSvpilRLiYcIDJp11O7IG94GStOa1XhBspzGC4=";
        allowedIPs =
          [ "172.16.16.0/24" "10.0.0.0/24" "10.0.1.0/24" "0.0.0.0/0" ];
        # persistentKeepalive = 25;
      };
    }
    {
      name = "work";
      port = 51821;
      ips = [ "192.168.4.2/32" ];
      host = "46.140.106.38";
      peer = {
        publicKey = "lZFtaxbeY24Z7F7yaJw4ua8vYWy8TkYMDnQVc7Cv6HU=";
        allowedIPs = [ "192.168.4.1/32" "192.168.4.2/32" "0.0.0.0/0" ];
        persistentKeepalive = 25;
      };
    }
  ];
in {
  options.m.net.vpn.wg = { enable = mkEnableOption "enables wireguard"; };

  config = mkIf cfg.enable {
    programs.bash.shellAliases = my.mapListToAttrs (i:
      map (a: {
        "wg-${i.name}-${a}" = "sudo systemctl ${a} wg-quick-${i.name}.service";
      }) [ "start" "stop" ]) ifaces;
    networking.firewall = { allowedUDPPorts = map (i: i.port) ifaces; };
    # yea so this doesn't work
    # sops.secrets."wg" = { };
    #
    # networking.wireguard.interfaces =
    #   lib.my.parseYaml config.sops.secrets."wg".path;
    #
    # systemd.services = lib.concatMapAttrs
    #   (name: value: { "wireguard-${cfg.name}".wantedBy = lib.mkForce [ ]; })
    #   (lib.my.parseYaml config.sops.secrets."wg".path);

    sops.secrets =
      my.mapListToAttrs (i: [{ "wg/${i.name}/privateKey" = { }; }]) ifaces;

    # prevent autostarting
    systemd.services = my.mapListToAttrs (i: [
      { "wireguard-${i.name}".wantedBy = mkForce [ ]; }
      { "wg-quick-${i.name}".wantedBy = mkForce [ ]; }
    ]) ifaces;
    # {
    #   wireguard-work.wantedBy = lib.mkForce [ ];
    #   wg-quick-work.wantedBy = lib.mkForce [ ];
    #   wireguard-pfsense.wantedBy = lib.mkForce [ ];
    #   wg-quick-pfsense.wantedBy = lib.mkForce [ ];
    # };

    # Enable WireGuard
    networking = {
      # dösent wörk
      # interfaces.wlp108s0.ipv4.routes = [{
      #   address = "10.0.0.10";
      #   prefixLength = 32;
      #   via = "10.0.0.1";
      #   options = { metric = "0"; };
      # }];
      # wg-quick.interfaces = my.mapListToAttrs
      #   (i: [{
      #     "${i.name}" = {
      #
      #       listenPort = i.port;
      #       privateKeyFile = config.sops.secrets."wg/${i.name}/privateKey".path;
      #       address = i.ips;
      #       postUp =
      #         "${pkgs.iproute}/bin/ip route add ${i.host} via 10.0.0.1 dev wlp108s0";
      #       postDown =
      #         "${pkgs.iproute}/bin/ip route del ${i.host} via 10.0.0.1 dev wlp108s0";
      #       peers = [ mkMerge [ i.peer { endpoint = "${i.host}:${i.port}"; } ] ];
      #     };
      #   }])
      #   ifaces;

      wg-quick.interfaces = let
        postUp = wgIf: wgIp: gateway:
          pkgs.writeShellScript "wg-post-up-${wgIf}" ''
            #!/bin/sh
            ip route add ${wgIp} via ${gateway} dev ${wgIf}
          '';
      in {
        pfsense = {
          #ips = [ "172.16.16.2/24" ];
          listenPort = 51820;
          privateKeyFile = config.sops.secrets."wg/pfsense/privateKey".path;
          address = [ "172.16.16.2/24" ];
          postUp =
            "${pkgs.iproute}/bin/ip route add 10.0.0.10 via 10.0.0.1 dev wlp108s0";
          postDown =
            "${pkgs.iproute}/bin/ip route del 10.0.0.10 via 10.0.0.1 dev wlp108s0";
          peers = [{
            publicKey = "dR9PUbSvpilRLiYcIDJp11O7IG94GStOa1XhBspzGC4=";
            allowedIPs =
              [ "172.16.16.0/24" "10.0.0.0/24" "10.0.1.0/24" "0.0.0.0/0" ];
            endpoint = "10.0.0.10:51820";
            # persistentKeepalive = 25;
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
  };
}
