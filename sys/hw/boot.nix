{ sys, ... }: {
  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader = {
    systemd-boot.enable = if (sys.bootMode == "uefi") then true else false;
    efi = {
      canTouchEfiVariables = if (sys.bootMode == "uefi") then true else false;
      efiSysMountPoint = sys.bootMountPath; # does nothing if running bios rather than uefi
    };
    # grub.efiInstallAsRemovable = true;
    # grub.efiSupport = true;
    grub = {
      enable = if (sys.bootMode == "uefi") then false else true;
      device = sys.grubDevice; # does nothing if running uefi rather than bios
      useOSProber = true;
      extraEntries = sys.extraGrubEntries;
    };
  };
}
