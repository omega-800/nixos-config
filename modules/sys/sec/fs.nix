{ config, sys, lib, ... }:
let
  cfg = config.m.sec.fs;
  inherit (lib) mkOption types mkIf mkMerge;
in
{
  options.m.sec.fs = {
    enable = mkOption {
      description = "hardens filesystem";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    fileSystems = {
      #FIXME: separate partitions
      # https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/installation_guide/s2-diskpartrecommend-x86#idm140491990747664
      # /                 8
      # /var              4
      # /var/log/audit    4
      # /home             4
      # /tmp              2
      # /swap             2
      "/home" = {
        device = "/home";
        options = [
          "bind"
          "nodev"
          "nosuid"
          "nouser"
          "auto"
          "async"
          "usrquota"
          "grpqouta"
          "rw"
        ] ++ (if sys.paranoid then [ "noexec" ] else [ "exec" ]);
      };
      "/root" = {
        device = "/root";
        options = [ "bind" "nodev" "nosuid" "nouser" "noexec" ];
      };
      "/tmp" = {
        device = "/tmp";
        options = [
          "bind"
          "nodev"
          "nosuid"
          "nouser"
          "noatime"
          "usrquota"
          "grpquota"
          "rw"
          "size=200M"
          "nr_inodes=5k"
          "mode=1700"
        ] ++ (if sys.paranoid then [ "noexec" ] else [ "exec" ]);
      };
      "/var" = {
        device = "/var";
        options = [
          "defaults"
          "bind"
          "nodev"
          "nosuid"
          "nouser"
          "noatime"
          "usrquota"
          "grpqouta"
        ] ++ (if sys.paranoid then [ "noexec" ] else [ "exec" ]);
      };
      "/var/lib" = {
        device = "/var/lib";
        options = [ "defaults" "bind" "nodev" "nosuid" "nouser" ]
          ++ (if sys.paranoid then [ "noexec" ] else [ "exec" ]);
      };
      "/boot" = {
        device = "/boot";
        options = [ "defaults" "nodev" "nosuid" "noexec" "umask=0077" ]
          ++ (if sys.paranoid then [ "ro" ] else [ ]);
      };
      "/srv" = {
        device = "/srv";
        options = [ "bind" "nodev" "noexec" "nosuid" "nouser" ];
      };
      "/etc" = {
        device = "/etc";
        options = [ "defaults" "bind" "nodev" "nosuid" "nouser" ];
      };
      "/etc/nixos" = {
        device = "/etc/nixos";
        options = [ "defaults" "bind" "nodev" "nosuid" "noexec" "nouser" ];
      };

      "/".options = [ "defaults" "noexec" "mode=755" ];
      "/usr".options = [ "defaults" "nodev" "errors=remount-ro" ];
      "/usr/share".options = [ "defaults" "nodev" "ro" "nosuid" ];
      "/swap".options = [ "defaults" "nodev" "noexec" "nosuid" "nouser" "sw" ];
      "/nix".options = [ "defaults" "nodev" "nosuid" "nouser" "noatime" ];
      "/nix/store".options = [ "defaults" "nodev" "nosuid" "nouser" "noatime" ];
      "/var/log".options =
        [ "defaults" "nodev" "noexec" "nosuid" "nouser" "rw" ];
      "/var/log/audit".options =
        [ "defaults" "nodev" "noexec" "nosuid" "nouser" "rw" ];
      "/var/tmp".options = [
        "defaults"
        "nodev"
        "noexec"
        "nosuid"
        "nouser"
        "usrquota"
        "grpqouta"
        "rw"
      ];
      "/mnt/fd0".options = [ "defaults" "nodev" "noexec" "nosuid" "ro" ];
      "/mnt/floppy".options = [ "defaults" "nodev" "noexec" "nosuid" "ro" ];
      "/mnt/cdrom".options = [ "defaults" "nodev" "noexec" "nosuid" "ro" ];
      "/mnt/tmp".options = [ "defaults" "nodev" "noexec" "nosuid" "ro" ];
    };
    boot.specialFileSystems = {
      "/dev/shm" = {
        fsType = "tmpfs";
        options = [
          "nodev"
          "noexec"
          "nosuid"
          "nouser"
          "strictatime"
          "mode=1777"
          "size=${config.boot.devShmSize}"
        ];
      };
      "/run" = {
        fsType = "tmpfs";
        options = [
          "nosuid"
          "nodev"
          "noexec"
          "strictatime"
          "mode=755"
          "size=${config.boot.runSize}"
        ];
      };
      "/dev" = {
        fsType = "devtmpfs";
        options = [
          "nosuid"
          "noexec"
          "strictatime"
          "mode=755"
          "size=${config.boot.devSize}"
        ];
      };
      "/proc" = {
        fsType = "proc";
        device = "proc";
        options = [
          "nodev"
          "noexec"
          "nosuid"
          "nouser"
          "noatime"
          "hidepid=${if sys.paranoid then "4" else "2"}"
          "gid=proc"
        ];
      };
    };
    users.groups.proc = { };
    systemd.services = {
      systemd-logind.serviceConfig.SupplementaryGroups = [ "proc" ];
      "user@".serviceConfig.SupplementaryGroups = [ "proc" ];
    };
  };
}
