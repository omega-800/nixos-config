{
  # Firewall
  networking.firewall = {
    enable = true;
    # Allow PMTU / DHCP
    allowPing = true;

    # Keep dmesg/journalctl -k output readable by NOT logging
    # each refused connection on the open internet.
    logRefusedConnections = false;

    # Open ports in the firewall.
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };
}
