{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "sd_mod"
      "sr_mod"
    ];
    initrd.kernelModules = [ ];
    extraModulePackages = [ ];
  };

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/3e578621-fca5-4613-979e-8dec12864c3e";
  #   fsType = "ext4";
  # };

  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/954189f8-a5a2-4081-a506-568f4aee68d5"; }
  # ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
