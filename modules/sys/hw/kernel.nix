{ sys, lib, config, pkgs, modulesPath, ... }:
with lib;
let cfg = config.m.hw.kernel;
in {
  options.m.hw.kernel = {
    zen = mkEnableOption "enables zen kernel";
    swappiness = mkOption {
      type = types.number;
      default = 60;
      description = "swappiness";
    };
  };
  # copied into this config
  # imports = if sys.paranoid then [ "${modulesPath}/profiles/hardened.nix" ] else [ ];
  imports = [ ./sysctl.nix ];
  config = (mkMerge [
    ({
      boot = {
        kernel.sysctl."vm.swappiness" = cfg.swappiness;
      };
    })
    (mkIf sys.hardened {
      boot = {
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
        kernelParams = [
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

        kernelParams = [
          #"lockdown=off"
          "lockdown=integrity"
          "ipv6.disable=1"
          "l1tf=full,force"
          "tsx=off"
          "tsx_async_abort=full,nosmt"
          "kvm.nx_huge_pages=force" # this one can increase memory usage, especially with hypervisors that use kvm
          # "nosmt=force", "tsx_async_abort=full,nosmt", and "mds=full,nosmt" all disable hyperthreading, which is really good for security, but if you use hyperthreading expect your PC's performance to half or more
          # https://pulsesecurity.co.nz/advisories/tpm-luks-bypass
          "rd.shell=0"
          "rd.emergency=reboot"
        ];
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
