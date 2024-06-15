{ config, ... }: {
  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader = {
    systemd-boot.enable = if (config.c.sys.bootMode == "uefi") then true else false;
    efi.canTouchEfiVariables = if (config.c.sys.bootMode == "uefi") then true else false;
    efi.efiSysMountPoint = config.c.sys.bootMountPath; # does nothing if running bios rather than uefi
    # grub.efiInstallAsRemovable = true;
    # grub.efiSupport = true;
    grub = {
      enable = if (config.c.sys.bootMode == "uefi") then false else true;
      device = config.c.sys.grubDevice; # does nothing if running uefi rather than bios
      useOSProber = true;
      extraEntries = config.c.sys.extraGrubEntries;
    };
  };
}
