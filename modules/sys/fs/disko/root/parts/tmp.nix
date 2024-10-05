{ config, lib, sys, ... }: {
  disko.devices = lib.mkIf config.m.fs.disko.enable {
    nodev."/tmp" = {
      fsType = "tmpfs";
      mountOptions = [
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
  };
  boot.tmp.cleanOnBoot = true;
}
