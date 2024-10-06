{ config, usr, lib, sys, ... }:
with lib;
let cfg = config.m.net.wifi;
in {
  options.m.net.wifi.enable = mkOption {
    description = "enables wifi";
    type = types.bool;
    default = sys.profile != "serv" && config.m.net.enable;
  };
  config = (mkMerge [
    (mkIf cfg.enable {
      networking.networkmanager = {
        enable = true;
        ethernet.macAddress = "random";
        wifi = {
          macAddress = "random";
          scanRandMacAddress = true;
        };
        # Enable IPv6 privacy extensions in NetworkManager.
        connectionConfig."ipv6.ip6-privacy" = lib.mkDefault 2;
      };
      users.users.${usr.username}.extraGroups = [ "networkmanager" ];
    })
    (mkIf (!usr.minimal) {
      #services.opensnitch.enable = true;
      programs.mtr.enable = true;
    })
    {
      environment.persistence =
        lib.mkIf config.m.fs.disko.root.impermanence.enable {
          "/nix/persist" = {
            directories = [ "/etc/NetworkManager/system-connections" ];
            files = [
              "/var/lib/NetworkManager/seen-bssids"
              "/var/lib/NetworkManager/timestamps"
              "/var/lib/NetworkManager/secret_key"
            ];
          };
        };
      networking = {
        wireless.enable = false;
        hostName = sys.hostname;
        extraHosts = ''
          127.0.0.1 local.sendy.inteco.ch
        '';
        #TODO: make configurable
        domain = lib.mkDefault "home.lan";
        enableIPv6 = lib.mkDefault false;
        # Use networkd instead of the pile of shell scripts
        useNetworkd = true;
        useDHCP = false;
        nameservers = [ "10.0.0.51" "1.1.1.1" "8.8.8.8" ];
      };

      # DNS connections will fail if not using a DNS server supporting DNSSEC.
      services.resolved = mkIf sys.hardened { dnssec = "true"; };

      # The notion of "online" is a broken concept
      # https://github.com/systemd/systemd/blob/e1b45a756f71deac8c1aa9a008bd0dab47f64777/NEWS#L13
      systemd = {
        services = {
          NetworkManager-wait-online.enable = false;
          # FIXME: Maybe upstream?
          # Do not take down the network for too long when upgrading,
          # This also prevents failures of services that are restarted instead of stopped.
          # It will use `systemctl restart` rather than stopping it with `systemctl stop`
          # followed by a delayed `systemctl start`.
          systemd-networkd.stopIfChanged = false;
          # Services that are only restarted might be not able to resolve when resolved is stopped before
          systemd-resolved.stopIfChanged = false;
        };
        network.wait-online.enable = false;
      };
    }
  ]);
}
