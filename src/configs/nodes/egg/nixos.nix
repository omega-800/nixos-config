{
  config,
  lib,
  ...
}:
{
imports = [./hardware-configuration.nix];
  /*
    sops.secrets = {
      "hosts/default/disk" = { };
    };
  */
  m = {
    /*
      fs.disko = {
        enable = true;
        root.device = "/dev/sda";
        pools.store = {
          stripe = true;
          devices = [
            "/dev/sdb"
            "/dev/sdc"
          ];
          keylocation = "file://${config.sops.secrets."hosts/default/disk".path}";
        };
      };
    */
    net.iface="enp9s0";
    os.boot.mode = "uefi";
  };

  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
  system.stateVersion = "25.05";
}
