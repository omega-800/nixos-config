{ config, lib, ... }:
let
  rootIsBtrfs = config.m.fs.disko.root.type == "btrfs";
  poolsAreBtrfs = lib.my.misc.poolsContainFs "btrfs" config.m.fs.disko;
in {
  config = lib.mkIf (rootIsBtrfs || poolsAreBtrfs) {
    services = {
      btrfs = {
        autoScrub = {
          enable = true;
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
