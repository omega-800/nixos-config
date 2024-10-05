{ config, lib, sys, ... }: {
  disko.devices.disk.root.content = lib.mkIf config.m.fs.disko.enable {
    type = "gpt";
    partitions.swap = {
      start = "-8GiB";
      end = "-0";
      type = "8200";
      content = {
        type = "swap";
        randomEncryption = true;
        mountpoint = "/swap";
        priority = 100; # prefer to encrypt as long as we have space for it
        mountOptions = [ "defaults" "nodev" "noexec" "nosuid" "nouser" "sw" ];
      };
    };
  };
}
