{ config, lib, ... }:
let
  rootIsZfs = config.m.fs.disko.root.type == "zfs";
  poolsAreZfs = lib.my.misc.poolsContainFs "zfs" config.m.fs.disko;
in
{
  config = lib.mkIf (rootIsZfs || poolsAreZfs) {
    boot.zfs = {
      enabled = true;
      forceImportAll = true;
      forceImportRoot = rootIsZfs;
    };
    services = {
      zfs = {
        autoScrub = {
          enable = true;
          interval = "quarterly";
        };
        #autoSnapshot.enable = true;
        trim = {
          enable = true;
          interval = "weekly";
        };
      };
      sanoid = {
        enable = true;
        interval = "daily";
        #TODO: configure sanoid
      };
    };
  };
}
