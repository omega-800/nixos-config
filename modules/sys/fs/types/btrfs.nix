{ config, lib, ... }:
let
  rootIsBtrfs = config.m.fs.disko.root.type == "btrfs";
  poolsAreBtrfs = lib.omega.misc.poolsContainFs "btrfs" config.m.fs.disko;
in {
  #TODO: mkEnableOption
  config =
    lib.mkIf (config.m.fs.disko.enable && (rootIsBtrfs || poolsAreBtrfs)) {
      boot = {
        supportedFilesystems.btrfs = true;
        initrd.supportedFilesystems.btrfs = true;
      };
      services = {
        btrfs = {
          autoScrub = {
            enable = lib.mkDefault true;
            interval = "quarterly";
            #TODO: filesystem
          };
        };
        btrbk = {
          instances = {
            #TODO: instances
          };
          #TODO: ssh
        };
      };
    };
}
