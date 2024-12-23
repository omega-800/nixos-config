{
  lib,
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
  nixpkgs = {
    config.allowUnsupportedSystem = true;
    hostPlatform.system = "armv7l-linux";
    buildPlatform.system = "x86_64-linux"; # If you build on x86 other wise changes this.
  };
  # ... extra configs as above
  # FIXME: conflicting values in (sd-image-raspberrypi.nix || disko)
  fileSystems."/" = {
    fsType = lib.mkForce "btrfs";
    device = lib.mkForce "/dev/mapper/cryptroot";
  };
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

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "22.05";
  #system.stateVersion = "23.11"; 
}
