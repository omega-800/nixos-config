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
    concatStringsSep
    ;
  inherit (lib.omega.cfg) getCfgAttrOfAllHosts filterCfgs;
  inherit (lib.omega.net.ip4)
    ipFromCfg
    toHostId
    with0Prefix
    network
    toStr
    ;
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
      networking.networkmanager.enable = true;
      users.users.${usr.username}.extraGroups = [ "networkmanager" ];
    })
    (mkIf (!usr.minimal) {
      #services.opensnitch.enable = true;
      programs.mtr.enable = true;
    })
    {
      users.users.${usr.username}.openssh.authorizedKeys.keys = flatten (
        getCfgAttrOfAllHosts "net" "pubkeys"
      );
      services.openssh.enable = true;
      programs.ssh.askPassword = mkForce "";
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
            # Google
            "8.8.8.8"
            # Cloudflare
            "1.1.1.1"
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
