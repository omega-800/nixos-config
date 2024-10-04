{ sys, lib, ... }: {
  config = lib.mkIf sys.hardened {
    fileSystems = {
      "/".options = [ "noexec" ];
      "/etc/nixos".options = [ "noexec" ];
      "/srv".options = [ "noexec" ];
      "/usr".options = [ "nodev" "errors=remount-ro" ];
      "/var".options = [ "nodev" "noexec" "nosuid" ];
      "/var/log".options = [ "noexec" ];
      "/proc".options = [ "nosuid" "nodev" "noexec" "hidepid=2" "gid=proc" ];
      "/boot".options = [ "nodev" "noexec" ];
      "/dev/shm".options = [ "nodev" "noexec" "nosuid" ];
      "/home".options = [ "nodev" "nosuid" ];
      "/tmp".options = [
        "nodev"
        "nosuid"
        "size=200M"
        "nr_inodes=5k"
        "nosuid"
        "noexec"
        "nodev"
        "rw"
        "mode=1700"
      ];
    };
    systemd.services.systemd-logind.serviceConfig.SupplementaryGroups =
      [ "proc" ];
    users.groups.proc = { };
    boot.tmp.cleanOnBoot = true;
  };
}
