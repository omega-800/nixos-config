{ CONFIGS, ... }:
{
  imports = [
    # basically like work profile but with fun enabled
    ../work/${CONFIGS.nixosConfigurations}.nix
  ];
  m = {
    net.vpn = {
      forti.enable = true;
      wg.enable = true;
      openvpn.enable = true;
      mullvad.enable = true;
    };
    fs.thunar.enable = true;
    dev.mysql.enable = false;
  };
}
