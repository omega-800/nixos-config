{ sys, lib, config, pkgs, modulesPath, ... }:
with lib;
let
  cfg = config.m.hw.kernel;
  blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"

    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cramfs"
    "efs"
    "erofs"
    "exofs"
    "freevxfs"
    "f2fs"
    "hfs"
    "hpfs"
    "jfs"
    "minix"
    "nilfs2"
    "ntfs"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "ufs"
  ];
in {
  options.m.hw.kernel = {
    zen = mkEnableOption "enables zen kernel";
    swappiness = mkOption {
      type = types.number;
      default = if sys.paranoid then 1 else 60;
      description = "swappiness";
    };
  };
  # copied into this config
  # imports = if sys.paranoid then [ "${modulesPath}/profiles/hardened.nix" ] else [ ];
  imports = [ ./sysctl.nix ];
  config = (mkMerge [
    ({ boot = { kernel.sysctl."vm.swappiness" = cfg.swappiness; }; })
    (mkIf sys.hardened {
      boot = {
        inherit blacklistedKernelModules;
        kernelParams = [
          #"lockdown=off"
          "lockdown=integrity"
          "slab_nomerge"
          "init_on_alloc=1"
          "init_on_free=1"
          "pti=on"
          "vsyscall=none"
          "oops=panic"
          "module.sig_enforce=1"
          "mce=0"
          "quiet"
          "loglevel=2"
          "spectre_v2=on"
          "spec_store_bypass_disable=on" # these two mitigate spectre, minimal resource usage
          "page_poison=1"
          "page_alloc.shuffle=1"
          "debugfs=off"
        ];
      };
    })
    (mkIf sys.paranoid {
      security = {
        lockKernelModules = true;
        protectKernelImage = true;
        allowUserNamespaces = true;
        allowSimultaneousMultithreading = false;
        # This is required by podman to run containers in rootless mode.
        unprivilegedUsernsClone = config.virtualisation.containers.enable;
      };
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_hardened;
        # https://github.com/Kicksecure/security-misc/tree/master/etc/modprobe.d
        blacklistedKernelModules = blacklistedKernelModules ++ [
          "joydev"
          "cdrom"
          "sr_mod"
          "psmouse"
          "snd_intel8x0"
          "tls"
          "virtio_balloon"
          "virtio_console"
          "amd76x_edac"
          "ath_pci"
          "evbug"
          "pcspkr"
          "snd_aw2"
          "snd_intel8x0m"
          "snd_pcsp"
          "usbkbd"
          "usbmouse"
        ];
        kernelParams = [
          "ipv6.disable=1"
          "l1tf=full,force"
          "tsx=off"
          "tsx_async_abort=full,nosmt"
          "kvm.nx_huge_pages=force" # this one can increase memory usage, especially with hypervisors that use kvm
          # "nosmt=force", "tsx_async_abort=full,nosmt", and "mds=full,nosmt" all disable hyperthreading, which is really good for security, but if you use hyperthreading expect your PC's performance to half or more
          # https://pulsesecurity.co.nz/advisories/tpm-luks-bypass
          "rd.shell=0"
          "rd.emergency=reboot"

          # Requires all kernel modules to be signed. This prevents out-of-tree
          # kernel modules from working unless signed. See overrides.
          "module.sig_enforce=1"

          # May break some drivers, same reason as the above. Also breaks
          # hibernation. See overrides.
          "lockdown=confidentiality"

          # May prevent some systems from booting. See overrides.
          "efi=disable_early_pci_dma"

          # Forces DMA to go through IOMMU to mitigate some DMA attacks. See
          # overrides.
          "iommu.passthrough=0"

          # Apply relevant CPU exploit mitigations, and disable symmetric 
          # multithreading. May harm performance. See overrides.
          "mitigations=auto,nosmt"

          # Mitigates Meltdown, some KASLR bypasses. Hurts performance. See
          # overrides.
          "pti=on"

          # Gather more entropy on boot. Only works with the linux_hardened
          # patchset, but does nothing if using another kernel. Slows down boot
          # time by a bit. 
          "extra_latent_entropy"

          # Disables multilib/32 bit applications to reduce attack surface.
          # See overrides.
          "ia32_emulation=0"

          "slab_nomerge"
          "init_on_alloc=1"
          "init_on_free=1"
          "page_alloc.shuffle=1"
          "randomize_kstack_offset=on"
          "vsyscall=none"
          "debugfs=off"
          "oops=panic"
          "quiet"
          "loglevel=0"
          "random.trust_cpu=off"
          "random.trust_bootloader=off"
          "intel_iommu=on"
          "amd_iommu=force_isolation"
          "iommu=force"
          "iommu.strict=1"
        ];

        # Disable the editor in systemd-boot, the default bootloader for NixOS.
        # This prevents access to the root shell or otherwise weakening
        # security by tampering with boot parameters. If you use a different
        # boatloader, this does not provide anything. You may also want to
        # consider disabling similar functions in your choice of bootloader.
        loader.systemd-boot.editor = false;
      };
    })
    (mkIf (cfg.zen && (!sys.paranoid)) {
      boot = {
        kernelPackages = mkDefault pkgs.linuxPackages_zen;
        consoleLogLevel = 0;
        kernelModules = [ "i2c-dev" "i2c-piix4" "cpufreq_powersave" ];
      };
    })
  ]);
}
