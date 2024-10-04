{ sys, lib, ... }: {
  config = lib.mkIf sys.hardened {
    fileSystems = {
      #FIXME: separate partitions
      # "/etc/nixos".options = [ "noexec" ];
      # "/srv".options = [ "noexec" ];
      # "/proc".options = [ "nosuid" "nodev" "noexec" "hidepid=2" "gid=proc" ];
      # "/dev/shm".options = [ "nodev" "noexec" "nosuid" ];
      # "/tmp".options = [
      #   "nodev"
      #   "nosuid"
      #   "size=200M"
      #   "nr_inodes=5k"
      #   "nosuid"
      #   "noexec"
      #   "nodev"
      #   "rw"
      #   "mode=1700"
      # ];
      # "/usr".options = [ "nodev" "errors=remount-ro" ];
      # "/var".options = [ "nodev" "noexec" "nosuid" ];
      # "/var/log".options = [ "noexec" ];
      "/".options = [ "noexec" ];
      "/boot".options = [ "nodev" "noexec" ];
      "/home".options = [ "nodev" "nosuid" ];
    };
    systemd.services.systemd-logind.serviceConfig.SupplementaryGroups =
      [ "proc" ];
    users.groups.proc = { };
    boot.tmp.cleanOnBoot = true;
  };
}
