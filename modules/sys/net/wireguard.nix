{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption types mkOption mkIf mapAttrs' attrsToList nameValuePair
    mkForce mkMerge;
  inherit (lib.omega.attrs) flatMapToAttrs;
  cfg = config.m.net.vpn.wg;
  defIfaces = {
    home = {
      port = 50100;
      ips = [ "172.16.16.2/24" ];
      host = "omega-800.duckdns.org";
      peer = {
        publicKey = "dR9PUbSvpilRLiYcIDJp11O7IG94GStOa1XhBspzGC4=";
        allowedIPs =
          [ "172.16.16.0/24" "10.0.0.0/24" "10.0.1.0/24" "0.0.0.0/0" ];
        # persistentKeepalive = 25;
      };
    };
    work = {
      port = 51821;
      ips = [ "192.168.4.2/32" ];
      host = "46.140.106.38";
      peer = {
        publicKey = "lZFtaxbeY24Z7F7yaJw4ua8vYWy8TkYMDnQVc7Cv6HU=";
        allowedIPs = [ "192.168.4.1/32" "192.168.4.2/32" "0.0.0.0/0" ];
      };
    };
  };
in {
  options.m.net.vpn.wg = {
    enable = mkEnableOption "enables wireguard";
    ifaces = let
      ifaceOpts = types.submodule {
        options = {
          port = mkOption {
            type = types.number;
            default = 51820;
            description = "wg port";
          };
          ips = mkOption {
            type = types.listOf types.nonEmptyStr;
            default = [ "192.168.4.2/32" ];
            description = "wg ips";
          };
          host = mkOption {
            type = types.nonEmptyStr;
            default = "1.1.1.1";
            description = "wg host";
          };
          peer = {
            publicKey = mkOption {
              type = types.nonEmptyStr;
              default = "changeme";
              description = "wg publicKey";
            };
            allowedIPs = mkOption {
              type = types.listOf types.nonEmptyStr;
              default = [ "192.168.4.1/32" "192.168.4.2/32" "0.0.0.0/0" ];
              description = "wg ips";
            };
          };
        };
      };
    in mkOption {
      type = types.nullOr (types.attrsOf ifaceOpts);
      description = "wg ifaces";
      default = defIfaces;
    };
  };

  config = mkIf cfg.enable {
    programs = flatMapToAttrs (i:
      map (sh: {
        "${sh}".shellAliases = flatMapToAttrs (action: [{
          "wg-${i.name}-${action}" =
            "sudo systemctl ${action} wg-quick-${i.name}.service";
        }]) [ "start" "stop" ];
      }) [ "zsh" "bash" "fish" ]) (attrsToList cfg.ifaces);

    networking.firewall.allowedUDPPorts =
      map (i: i.value.port) (attrsToList cfg.ifaces);

    sops.secrets =
      mapAttrs' (n: v: nameValuePair "wg/${n}/privateKey" { }) cfg.ifaces;

    # prevent autostarting
    systemd.services = flatMapToAttrs (i: [
      { "wireguard-${i.name}".wantedBy = mkForce [ ]; }
      { "wg-quick-${i.name}".wantedBy = mkForce [ ]; }
    ]) (attrsToList cfg.ifaces);

    # Enable WireGuard
    networking = {
      # dösent wörk
      /* interfaces.wlp108s0.ipv4.routes = [{
           address = "10.0.0.10";
           prefixLength = 32;
           via = "10.0.0.1";
           options = { metric = "0"; };
         }];
      */
      wg-quick.interfaces = mapAttrs' (n: v:
        nameValuePair "${n}" {
          listenPort = v.port;
          privateKeyFile = config.sops.secrets."wg/${n}/privateKey".path;
          address = v.ips;
          # postUp =
          #   "${pkgs.iproute}/bin/ip route add ${i.host} via 10.0.0.1 dev wlp108s0";
          # postDown =
          #   "${pkgs.iproute}/bin/ip route del ${i.host} via 10.0.0.1 dev wlp108s0";
          peers = [
            (mkMerge [
              v.peer
              {
                endpoint = "${v.host}:${toString v.port}";
                persistentKeepalive = 25;
              }
            ])
          ];
        }) cfg.ifaces;

      /* wg-quick.interfaces =
         let
           postUp = wgIf: wgIp: gateway:
             pkgs.writeShellScript "wg-post-up-${wgIf}" ''
               #!/bin/sh
               ip route add ${wgIp} via ${gateway} dev ${wgIf}
             '';
         in
         {
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
         };
      */
    };
  };
}
