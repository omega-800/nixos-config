{ config, lib, sys, ... }: {
  config = lib.mkIf config.m.fs.disko.enable {
    disko.devices.disk.root.content = {
      type = "gpt";
      partitions =
        if (config.m.os.boot.mode == "bios") then {
          boot = {
            #label = "boot";
            priority = 1;
            start = "0";
            size = "1M";
            type = "EF02";
          };
        } else {
          ESP = {
            label = "boot";
            name = "ESP";
            priority = 1;
            start = "0";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = config.m.os.boot.efiPath;
              mountOptions = [ "umask=0077" ];
            };
          };
        };
    };
  };
}
