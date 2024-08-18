{ usr, ... }: {
  imports = [ ];
  m = {
    kernel = {
      zen = false;
      swappiness = 15;
    };
    docker.enable = true;
    virt.enable = true;
    automount.enable = true;
    macchanger.enable = true;
    vpn = {
      forti.enable = false;
      mullvad.enable = false;
      openvpn.enable = false;
      wg.enable = true;
    };
  };
}
