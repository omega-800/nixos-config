{ ... }: {
  imports = [
    # basically like work profile but with fun enabled
    ../work/configuration.nix
  ];
  m = {
    vpn = {
      forti.enable = true;
      wg.enable = true;
      openvpn.enable = true;
      mullvad.enable = true;
    };
  };
}
