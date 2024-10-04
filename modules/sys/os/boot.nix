{ sys, config, lib, ... }:
with lib;
let
  cfg = config.m.os.boot;
  configurationLimit =
    if sys.profile == "serv" then 5 else if cfg.mode == "ext" then 2 else 15;
in
{
  options.m.os.boot = {
    grubDevice = mkOption {
      type = types.str;
      default = config.m.fs.disko.root.device;
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
  config.boot = mkMerge [
    (mkIf (builtins.elem "child" sys.flavors) {
      kernelParams =
        [
          "quiet"
          "console=tty0"
          "console=ttyS0,115200"
        ];
      loader.grub.extraConfig = ''
        serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
        terminal_input serial
        terminal_output serial
      '';
    })
    {
      # Bootloader
      loader = {
        #TODO: figure out how syslinux works
        # Enables the generation of /boot/extlinux/extlinux.conf
        generic-extlinux-compatible.enable = cfg.mode == "ext";

        # Use systemd-boot if uefi
        systemd-boot = {
          inherit configurationLimit;
          enable = cfg.mode == "uefi";
        };
        efi = {
          canTouchEfiVariables = cfg.mode == "uefi";
          # does nothing if running bios rather than uefi
          efiSysMountPoint = cfg.efiPath;
        };
        # grub.efiInstallAsRemovable = true;
        # grub.efiSupport = true;
        grub = {
          inherit configurationLimit;
          enable = lib.mkDefault cfg.mode == "bios";
          zfsSupport =
            let d = config.m.fs.disko;
            in d.enable && lib.my.misc.poolsContainFs "zfs" d;
          device = cfg.grubDevice; # does nothing if running uefi rather than bios
          useOSProber = true;
        };
      };
    }
  ];
};
}
