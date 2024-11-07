{
  config,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # https://nixos.wiki/wiki/NixOS_on_ARM
    "${modulesPath}/installer/sd-card/sd-image-raspberrypi.nix"
  ];
  nixpkgs.config.allowUnsupportedSystem = true;
  nixpkgs.hostPlatform.system = "armv7l-linux";
  nixpkgs.buildPlatform.system = "x86_64-linux"; # If you build on x86 other wise changes this.
  # ... extra configs as above
  m = {
    fs.disko = {
      enable = true;
      root = {
        device = "/dev/mmcblk0";
        impermanence.enable = true;
      };
    };
    hw.power.enable = false;
    os.boot.mode = "ext";
    dev = {
      docker.enable = false;
      virt.enable = false;
      mysql.enable = false;
    };
    net.vpn.wg.enable = false;
  };
  networking = {
    hostId = "ffffff00";
    defaultGateway = {
      address = "10.100.0.1";
      interface = "eth0";
    };
    interfaces = {
      eth0 = {
        name = "eth0";
        useDHCP = false;
        wakeOnLan = {
          enable = true;
          policy = [ "magic" ];
        };
        ipv4 = {
          addresses = [
            {
              address = "10.100.0.10";
              # address = "10.0.5.121";
              prefixLength = 24;
            }
          ];
        };
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "22.05";
  #system.stateVersion = "23.11"; 
}
