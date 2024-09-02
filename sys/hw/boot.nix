{ sys, lib, ... }:
with lib;
let cfg = config.m.boot;
in {
  options.m.boot = {
    extraGrubEntries = mkOption {
      type = types.str;
      default = "";
    };
    bootMode = mkOption {
      type = types.str;
      default = "uefi";
    }; # uefi or bios or ext
    bootMountPath = mkOption {
      type = types.str;
      default = "/boot";
    }; # mount path for efi boot partition: only used for uefi boot mode
    grubDevice = mkOption {
      type = types.str;
      default = "/dev/sda";
    }; # device identifier for grub: only used for legacy (bios) boot mode
  };
  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  config.boot.loader = {
    # Enables the generation of /boot/extlinux/extlinux.conf
    generic-extlinux-compatible.enable = cfg.bootMode == "ext";

    systemd-boot.enable = cfg.bootMode == "uefi";
    efi = {
      canTouchEfiVariables = cfg.bootMode == "uefi";
      efiSysMountPoint =
        cfg.bootMountPath; # does nothing if running bios rather than uefi
    };
    # grub.efiInstallAsRemovable = true;
    # grub.efiSupport = true;
    grub = {
      enable = cfg.bootMode == "bios";
      device = cfg.grubDevice; # does nothing if running uefi rather than bios
      useOSProber = true;
      extraEntries = cfg.extraGrubEntries;
    };
  };
}
