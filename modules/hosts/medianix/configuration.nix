{ config,lib, pkgs, ... }: {

imports = [
( import ../../sys/disko/serv-zfs.nix {inherit lib; keylocation = "file://${pkgs.writeText "secret.key" "passphrasemin8chars"}"; nDisks = 2; stripe = true;} ) 
../../sys/disko/root-btrfs.nix
];
  m.os.boot = { mode = "bios"; };
disko.devices.disk = {

root.device = "/dev/sda";
data1.device = "/dev/sdb";
data2.device = "/dev/sdc";
};
  networking.hostId = "5657ea3d";
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelParams = [ "quiet" "console=tty0" "console=ttyS0,115200" ];

  boot.loader.grub.extraConfig = ''
    serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
    terminal_input serial
    terminal_output serial
  '';
boot.kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
  system.stateVersion = "24.05";
}
