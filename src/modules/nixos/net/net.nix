{
  config,
  lib,
  usr,
  sys,
  net,
  ...
}:
let
  cfg = config.m.net;
  inherit (lib)
    mkOption
    types
    mkMerge
    mkIf
    mkForce
    flatten
    listToAttrs
    nameValuePair
    concatStringsSep
    ;
  inherit (lib.omega.cfg) getCfgAttrOfMatchingHosts filterCfgs;
  inherit (lib.omega.net.ip4)
    ipFromCfg
    toHostId
    with0Prefix
    network
    toStr
    ;
  wifis = [
    "net-home"
    "net-shared"
    "tilde"
  ];
in
{
  options.m.net = {
    wifi.enable = mkOption {
      description = "enables wifi";
      type = types.bool;
      default = sys.profile != "serv";
    };
    wol.enable = mkOption {
      description = "enables wake on lan";
      type = types.bool;
      default = sys.profile == "serv";
    };
    iface = mkOption {
      description = "primary interface";
      type = types.str;
      default = "eth0";
    };
  };
  config = mkMerge [
    (mkIf cfg.wifi.enable {
      users.users.${usr.username}.extraGroups = [ "networkmanager" ];
      sops.secrets = listToAttrs (map (id: nameValuePair "wifi/${id}" { }) wifis);
      networking.networkmanager = {
        enable = true;
        ensureProfiles = {
          secrets.entries =
            if cfg.wifi.enable then
              (map (id: {
                file = config.sops.secrets."wifi/${id}".path;
                matchId = id;
                matchType = "wifi";
                matchSetting = "wifi-security";
                key = "psk";
              }) wifis)
            else
              [ ];
          profiles = listToAttrs (
            map (
              id:
              nameValuePair id {
                connection = {
                  inherit id;
                  type = "wifi";
                };
                ipv4 = {
                  method = "auto";
                };
                ipv6 = {
                  addr-gen-mode = "stable-privacy";
                  method = "auto";
                };
                proxy = { };
                wifi = {
                  mode = "infrastructure";
                  ssid = id;
                };
                wifi-security = {
                  auth-alg = "open";
                  key-mgmt = "wpa-psk";
                };
              }
            ) wifis
          );
        };
      };
    })
    (mkIf (sys.profile == "school") {
      programs.wireshark = {
        enable = true;
        dumpcap.enable = true;
        usbmon.enable = true;
      };
    })
    (mkIf (!usr.minimal) {
      #services.opensnitch.enable = true;
      programs.mtr.enable = true;
    })
    {
      # FIXME: only for orchestrator hosts
      users.users.${usr.username}.openssh.authorizedKeys.keys = flatten (
        getCfgAttrOfMatchingHosts (c: builtins.elem "master" c.sys.flavors) "net" "pubkeys"
      );
      environment.variables.SSH_ASKPASS = lib.mkForce "";
      networking = mkMerge [
        {
          inherit (net) domain;
          hostName = net.hostname;
          extraHosts = ''
            127.0.0.1 local.sendy.inteco.ch
            ${concatStringsSep "\n" (
              map (c: "${(ipFromCfg c.net).address} ${c.net.hostname}.${c.net.domain}") (
                filterCfgs (c: c.net.network != "dynamic")
              )
            )}
          '';
          nameservers = [
            # Cloudflare
            "1.1.1.1"
            # pfsense
            "10.2.2.1"
            # Google
            "8.8.8.8"
            # DNSWatch
            "84.200.69.80"
            # Quad9
            "208.67.222.222"
          ];
        }
        (
          if (net.network == "dynamic") then
            {
              hostId = "69420${with0Prefix net.id}";
            }
          else
            let
              ip = ipFromCfg net;
            in
            {
              hostId = toHostId ip;
              defaultGateway = {
                address = toStr ((network ip) // { d = 1; });
                interface = cfg.iface;
              };
              interfaces."${cfg.iface}" = {
                name = cfg.iface;
                useDHCP = false;
                wakeOnLan = mkIf cfg.wol.enable {
                  enable = true;
                  policy = [ "magic" ];
                };
                ipv4.addresses = [
                  {
                    inherit (ip) address prefixLength;
                  }
                ];
              };
            }
        )
      ];
    }
  ];
}
