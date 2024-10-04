{ config, lib, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  m.os.boot.mode = "bios";
  m.dev.virt.enable = false;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelParams = [ "quiet" "console=tty0" "console=ttyS0,115200" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader.grub.extraConfig = ''
    serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
    terminal_input serial
    terminal_output serial
  '';
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "24.05";
}
