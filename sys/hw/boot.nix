{ sys, ... }: {
  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader = {
    # Enables the generation of /boot/extlinux/extlinux.conf
    generic-extlinux-compatible.enable = sys.bootMode == "ext";

    systemd-boot.enable = sys.bootMode == "uefi";
    efi = {
      canTouchEfiVariables = sys.bootMode == "uefi";
      efiSysMountPoint = sys.bootMountPath; # does nothing if running bios rather than uefi
    };
    # grub.efiInstallAsRemovable = true;
    # grub.efiSupport = true;
    grub = {
      enable = sys.bootMode == "grub";
      device = sys.grubDevice; # does nothing if running uefi rather than bios
      useOSProber = true;
      extraEntries = sys.extraGrubEntries;
    };
  };
}
