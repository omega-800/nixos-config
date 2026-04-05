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
      mullvad.enable = false;
    };
    fs.thunar.enable = true;
    dev = {
      mysql.enable = false;
      android.enable = true;
    };
  };
}
