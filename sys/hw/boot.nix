{ systemSettings, ... }: {
  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader.systemd-boot.enable = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.canTouchEfiVariables = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.grub.efiSupport = true;
  boot.loader.grub.enable = if (systemSettings.bootMode == "uefi") then false else true;
  boot.loader.grub.device = systemSettings.grubDevice; # does nothing if running uefi rather than bios
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.extraEntries = systemSettings.extraGrubEntries;
}
