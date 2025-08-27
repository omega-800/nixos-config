{ CONFIGS, ... }:
{
  imports = [
    ../work/${CONFIGS.nixosConfigurations}.nix
  ];
  m = {
    net.vpn = {
      forti.enable = false;
      wg.enable = true;
      openconnect.enable = true;
    };
    fs.thunar.enable = true;
    dev = {
      mysql.enable = false;
      android.enable = true;
    };
  };
}
