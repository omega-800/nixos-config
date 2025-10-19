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
    os.boot = {
	mode = "uefi";
	};
net.iface="enp9s0";
  };

  boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
  system.stateVersion = "24.05";
}
