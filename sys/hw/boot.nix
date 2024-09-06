{ sys, config, lib, ... }:
with lib;
let cfg = config.m.boot;
in {
  options.m.boot = {
    grubDevice = mkOption {
      type = types.str;
      default = "/dev/sda";
      description =
        "device identifier for grub: only used for legacy (bios) boot mode";
    };
    mode = mkOption {
      type = types.enum [ "ext" "uefi" "bios" ];
      default = "uefi";
      description = "boot mode";
    };
    efiPath = mkOption {
      type = types.str;
      default = "/boot";
      description =
        "mount path for efi boot partition: only used for uefi boot mode";
    };
  };
  config.boot = {
    # Ensure a clean & sparkling /tmp on fresh boots.
    tmp.cleanOnBoot = sys.profile == "serv";
    # Bootloader
    loader = {
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = cfg.mode == "ext";

      # Use systemd-boot if uefi
      systemd-boot = {
        enable = cfg.mode == "uefi";
        configurationLimit = if sys.profile == "serv" then 5 else 15;
      };
      efi = {
        canTouchEfiVariables = cfg.mode == "uefi";
        # does nothing if running bios rather than uefi
        efiSysMountPoint = cfg.efiPath;
      };
      # grub.efiInstallAsRemovable = true;
      # grub.efiSupport = true;
      grub = {
        enable = cfg.mode == "bios";
        configurationLimit = if sys.profile == "serv" then 5 else 15;
        device = cfg.grubDevice; # does nothing if running uefi rather than bios
        useOSProber = true;
      };
    };
  };
}
