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
      # "/".options = [ "defaults" "noexec" "mode=755" ];
      # "/boot".options = [ "defaults" "nodev" "noexec" "umask=0077" "ro" ];
      # "/home".options = [ "nodev" "nosuid" "nouser" /* limit? "exec" */ "auto" "async" "usrquota" "grpqouta" "rw" ];
      # "/srv".options = [ "nodev" "noexec" "nosuid" "nouser" ];
      # "/proc".options = [ "nodev" "noexec" "nosuid" "nouser" "noatime" "hidepid=2" "gid=proc" ];
      # "/usr".options = [ "defaults" "nodev" "errors=remount-ro" ];
      # "/usr/share".options = [ "defaults" "nodev" "ro" "nosuid" ];
      # "/swap".options = [ "defaults" "nodev" "noexec" "nosuid" "nouser" "sw" ];
      # "/nix".options = [ "defaults" "nodev" "nosuid" "nouser" "noatime" ];
      # "/nix/store".options = [ "defaults" "nodev" "nosuid" "nouser" "noatime" ];
      # "/etc".options = [ "defaults" "nodev" "nouser" ];
      # "/etc/nixos".options = [ "defaults" "nodev" "noexec" "nouser" ];
      # "/var".options = [ "defaults" "nodev" /*"noexec"*/ "nosuid" "nouser" "noatime"  "usrquota" "grpqouta" ];
      # "/var/log".options = [ "defaults" "nodev" "noexec" "nosuid" "nouser" "rw" ];
      # "/var/log/audit".options = [ "defaults" "nodev" "noexec" "nosuid" "nouser" "rw" ];
      # "/var/tmp".options = [ "defaults" "nodev" "noexec" "nosuid" "nouser" "usrquota" "grpqouta" "rw" ];
      # "/dev/shm".options = [ "nodev" "noexec" "nosuid" "nouser" ];
      # "/mnt/fd0".options = [ "defaults" "nodev" "noexec" "nosuid" "ro" ];
      # "/mnt/floppy".options = [ "defaults" "nodev" "noexec" "nosuid" "ro" ];
      # "/mnt/cdrom".options = [ "defaults" "nodev" "noexec" "nosuid" "ro" ];
      # "/mnt/tmp".options = [ "defaults" "nodev" "noexec" "nosuid" "ro" ];
      # "/tmp".options = [ "defaults" "nodev" "noexec" "nosuid" "nouser" "noatime" "usrquota" "grpquota" "rw" "size=200M" "nr_inodes=5k" "mode=1700" ];

      # https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/installation_guide/s2-diskpartrecommend-x86#idm140491990747664
      # /                 8
      # /var              4
      # /var/log/audit    4
      # /home             4
      # /tmp              2
      # /swap             2
    };
    systemd.services.systemd-logind.serviceConfig.SupplementaryGroups =
      [ "proc" ];
    users.groups.proc = { };
    boot.tmp.cleanOnBoot = true;
  };
}
