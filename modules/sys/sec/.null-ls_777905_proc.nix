{ sys, lib, ... }: {
  config = lib.mkIf sys.hardened {
    fileSystems = {
      "/".options = [ "noexec" ];
      "/etc/nixos".options = [ "noexec" ];
      "/srv".options = [ "noexec" ];
      "/usr".options = [ "nodev" "errors=remount-ro" ];
      "/var/log".options = [ "noexec" ];
      "/proc".options = [ "nosuid" "nodev" "noexec" "hidepid=2" "gid=proc" ];
    };
    systemd.services.systemd-logind.serviceConfig.SupplementaryGroups =
      [ "proc" ];
    users.groups.proc = { };
  };
}
