{ config, lib, ... }:
let
  cfg = config.m.fs.disko;
in
{
  config = lib.mkIf (cfg.enable && cfg.root.type == "zfs") {
    boot.initrd = lib.mkIf cfg.root.impermanence.enable {
      #TODO:  
      # finish
      # https://grahamc.com/blog/erase-your-darlings/
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zroot@blank
      '';
    };

    disko.devices = {
      disk.root = {
        inherit (cfg.root) device;
        type = "disk";
        content = {
          type = "gpt";
          partitions.root = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
      zpool.zroot = {
        type = "zpool";
        options.cachefile = "none";
        # mode = "";
        # rootFsOptions = {
        #   compression = "zstd";
        #   "com.sun:auto-snapshot" = "true";
        # };
        # mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
          };
          log = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options."com.sun:auto-snapshot" = "true";
          };
          persist = {
            type = "zfs_fs";
            mountpoint = "/nix/persist";
            options."com.sun:auto-snapshot" = "true";
          };
        };
      };
    };
  };
}
