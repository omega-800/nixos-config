{ config, lib, pkgs, inputs, ... }: {
  sops.secrets = { "hosts/default/disk" = { }; };
  m = {
    fs.disko = {
      enable = true;
      root.device = "/dev/sda";
      pools.store = {
        stripe = true;
        devices = [ "/dev/sdb" "/dev/sdc" ];
        keylocation = "file://${config.sops.secrets."hosts/default/disk".path}";
      };
    };
    os.boot.mode = "bios";
  };

  networking = {
    hostId = "5657ea3d";
    interfaces = {
      eth0 = {
        name = "eth0";
        useDHCP = false;
        wakeOnLan = {
          enable = true;
          policy = [ "magic" ];
        };
        ipv4 = {
          addresses = [{
            address = "10.0.0.121";
            # address = "10.0.5.121";
            prefixLength = 24;
          }];
        };
      };
    };
  };

  boot.kernelPackages =
    lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
  system.stateVersion = "24.05";
}
