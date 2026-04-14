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
  inherit (builtins) elem;
  inherit (lib.omega.cfg) mkSpecialisation getCfgAttrOfMatchingHosts filterCfgs;
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
      default = !(elem "serv" sys.profile);
    };
    wol.enable = mkOption {
      description = "enables wake on lan";
      type = types.bool;
      default = elem "serv" sys.profile;
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
      sops = {
        secrets = listToAttrs (map (id: nameValuePair "wifi/${id}" { }) (wifis ++ [ "eduroam" ]));
        templates = listToAttrs (
          map (
            id:
            nameValuePair "wifi-${id}.env" {
              content = ''
                PSK_${lib.toUpper id}=${config.sops.placeholder."wifi/${id}"}
              '';
            }
          ) (wifis ++ [ "eduroam" ])
        );
      };
      networking = {
        networkmanager = {
          enable = true;
          logLevel = "INFO";
          ensureProfiles = {
            environmentFiles = map (id: config.sops.templates."wifi-${id}.env".path) (wifis ++ [ "eduroam" ]);
            # secrets.entries =
            #   (map (id: {
            #     file = config.sops.secrets."wifi/${id}".path;
            #     matchId = id;
            #     matchType = "wifi";
            #     matchSetting = "wifi-security";
            #     # matchSetting = "802-11-wireless-security";
            #     key = "psk";
            #   }) wifis)
            #   ++ [
            #     {
            #       file = config.sops.secrets."vpn/school/password".path;
            #       # matchId = "eduroam";
            #       # matchType = "wifi";
            #       matchUuid = "77b3db2d-8580-4a21-a1d2-5488e70f4309";
            #       matchSetting = "802-1x";
            #       key = "password";
            #     }
            #   ];
            profiles =
              listToAttrs (
                map (
                  id:
                  nameValuePair id {
                    connection = {
                      inherit id;
                      type = "wifi";
                    };
                    ipv4.method = "auto";
                    ipv6 = {
                      addr-gen-mode = "stable-privacy";
                      method = "auto";
                    };
                    proxy = { };
                    wifi = {
                      mode = "infrastructure";
                      ssid = id;
                      # scan-rand-mac-address = "no";
                      # cloned-mac-address = "random";
                    };
                    # "802-11-wireless-security".psk = "$PSK_${lib.toUpper id}";
                    wifi-security = {
                      auth-alg = "open";
                      key-mgmt = "wpa-psk";
                      psk = "$PSK_${lib.toUpper id}";
                    };
                  }
                ) wifis
              )
              // {
                # nmcli connection add \
                #   type wifi \
                #   connection.id PROFILE_NAME \
                #   wifi.ssid SSID \
                #   wifi.mode infrastructure \
                #   wifi-sec.key-mgmt wpa-eap \
                #   802-1x.eap peap \
                #   802-1x.identity IDENTITY \
                #   802-1x.phase2-auth mschapv2 \
                #   802-1x.password PASSWORD
                eduroam = {
                  connection = {
                    id = "eduroam";
                    uuid = "77b3db2d-8580-4a21-a1d2-5488e70f4309";
                    type = "wifi";
                  };
                  wifi = {
                    mode = "infrastructure";
                    ssid = "eduroam";
                    scan-rand-mac-address = "no";
                    cloned-mac-address = "random";
                  };
                  wifi-security.key-mgmt = "wpa-eap";
                  "802-1x" = {
                    eap = "peap;";
                    # TODO: configure in one place only
                    identity = "georgiy.shevoroshkin@ost.ch";
                    phase2-auth = "mschapv2";
                    password = "$PSK_EDUROAM";
                  };
                  ipv4.method = "auto";
                  ipv6 = {
                    addr-gen-mode = "default";
                    method = "auto";
                  };
                };
              };
          };
        };
      };
    })
    (mkSpecialisation "school" {
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
