{
  sys,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkMerge
    mkIf
    omega
    mkDefault
    ;
  cfg = config.m.os.boot;
  configurationLimit =
    if sys.profile == "serv" then
      5
    else if cfg.mode == "ext" then
      2
    else
      15;
in
{
  options.m.os.boot = {
    grubDevice = mkOption {
      type = types.str;
      default = config.m.fs.disko.root.device;
      description = "device identifier for grub: only used for legacy (bios) boot mode";
    };
    mode = mkOption {
      type = types.enum [
        "ext"
        "uefi"
        "bios"
      ];
      default = "uefi";
      description = "boot mode";
    };
    efiPath = mkOption {
      type = types.str;
      default = "/boot";
      description = "mount path for efi boot partition: only used for uefi boot mode";
    };
  };

  config = mkMerge [
    (mkIf (builtins.elem "child" sys.flavors) {
      boot = {
        kernelParams = [
          "quiet"
          "console=tty0"
          "console=ttyS0,115200"
        ];
        loader.grub.extraConfig = ''
          serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
          terminal_input serial
          terminal_output serial
        '';
      };
    })
    {
      # Bootloader
      boot = {
        initrd.kernelModules = mkIf (cfg.mode == "uefi") [ "vfat" 
# TODO: remove
        "dm-snapshot"
        # Kernel modules needed for mounting USB VFAT devices in initrd stage
        "uas"
        "usbcore"
        "usb_storage"
        "vfat"
        "nls_cp437"
        "nls_iso8859_1"
];
# TODO: remove
      initrd.availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        # makes decryption faster? idk
        "aesni_intel"
        "cryptd"
      ];
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
          grub =
            let
              d = config.m.fs.disko;
            in
            {
              inherit configurationLimit;
              enable = cfg.mode == "bios";
              enableCryptodisk = d.enable && d.root.encrypt;
              zfsSupport =

                d.enable && omega.misc.poolsContainFs "zfs" d;
              device = cfg.grubDevice; # does nothing if running uefi rather than bios
              # otherwise devices get duplicated?
              devices = lib.optionals config.m.fs.disko.enable (lib.mkForce [ cfg.grubDevice ]);
              useOSProber = true;
              # FIXME: enable this again
              # users = mkIf sys.hardened {
              #   root.hashedPasswordFile = config.users.users.root.hashedPasswordFile;
              # };
            };
        };
      };
    }
  ];
}
