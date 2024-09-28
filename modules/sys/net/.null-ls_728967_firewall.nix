{ config, lib, sys, ... }:
with lib;
let cfg = config.m.net.firewall;
in {
  options.m.net.firewall.enable = mkOption {
    description = "enables firewall";
    type = types.bool;
    default = sys.hardened && config.m.net.enable;
  };
  # sops.secrets.sshd_port = {};
  # Enable incoming ssh
  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;
      # Allow PMTU / DHCP
      #allowPing = true;
      allowPing = sys.paranoid;

      # Keep dmesg/journalctl -k output readable by NOT logging
      # each refused connection on the open internet.
      logRefusedConnections = false;

      # Open ports in the firewall.
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
