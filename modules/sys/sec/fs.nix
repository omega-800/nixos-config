{ lib, sys, ... }: {
  config = lib.mkIf sys.hardened {
    fileSystems."/proc".options =
      [ "nosuid" "nodev" "noexec" "hidepid=2" "gid=proc" ];
    systemd-logind.serviceConfig.SupplementaryGroups = [ "proc" ];
    users.groups.proc = { };
  };
}
