{ config, lib, ... }:
let
  rootIsBtrfs = config.m.fs.disko.root.type == "btrfs";
  poolsAreBtrfs = lib.my.misc.poolsContainFs "btrfs" config.m.fs.disko;
in {
  config =
    lib.mkIf (config.m.fs.disko.enable && (rootIsBtrfs || poolsAreBtrfs)) {
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
