{ config, lib, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  m.os.boot.mode = "bios";
  m.dev.virt.enable = false;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "24.05";
}
