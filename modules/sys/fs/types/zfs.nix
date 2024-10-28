{ config, lib, ... }:
let
  rootIsZfs = config.m.fs.disko.root.type == "zfs";
  poolsAreZfs = lib.omega.misc.poolsContainFs "zfs" config.m.fs.disko;
in
{
  #TODO: mkEnableOption
  config = lib.mkIf (config.m.fs.disko.enable && (rootIsZfs || poolsAreZfs)) {
    boot = {
      supportedFilesystems.zfs = true;
      initrd.supportedFilesystems.zfs = true;
      zfs = {
        #enabled = true;
        forceImportAll = rootIsZfs;
        forceImportRoot = rootIsZfs;
      };
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
