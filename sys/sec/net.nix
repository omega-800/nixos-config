{ sys, ... }: {
  networking = {
    # Pick only one of the below networking options.
    # Enables wireless support via wpa_supplicant.
    wireless.enable = false;
    # Easiest to use and most distros use this by default.
    networkmanager.enable = true;
    hostName = sys.hostname;
    extraHosts = ''
      127.0.0.1 local.sendy.inteco.ch
    '';
    # Use networkd instead of the pile of shell scripts
    useNetworkd = true;
    useDHCP = false;
  };
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
  #services.opensnitch.enable = true;
  programs.mtr.enable = true;
}
