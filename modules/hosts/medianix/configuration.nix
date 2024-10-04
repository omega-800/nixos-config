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

  networking.hostId = "5657ea3d";
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelParams = [ "quiet" "console=tty0" "console=ttyS0,115200" ];

  boot.loader.grub.extraConfig = ''
    serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
    terminal_input serial
    terminal_output serial
  '';
  boot.kernelPackages =
    lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
  system.stateVersion = "24.05";
}
