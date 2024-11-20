defPartitions:
{ config, lib, ... }:
let
  cfg = config.m.fs.disko;
  inherit (lib) mkIf mkMerge mkAfter;
in
{
  config = mkIf (cfg.enable && cfg.root.type == "zfs") {
    boot.initrd = mkIf cfg.root.impermanence.enable {
      #TODO:  
      # finish
      # https://grahamc.com/blog/erase-your-darlings/
      postDeviceCommands = mkAfter ''
        zfs rollback -r zroot@blank
      '';
    };

    disko.devices = {
      disk.root = {
        inherit (cfg.root) device;
        type = "disk";
        content = {
          type = "gpt";
          # TODO: zfs encryption  
          partitions = defPartitions // {
            root = mkMerge [
              {
                end = "-8GiB";
              }
              (
                # TODO: abstract away luks boilerplate
                if cfg.root.encrypt then
                  {
                    label = "luks";
                    content = {
                      extraOpenArgs = [
                        "--perf-no_read_workqueue"
                        "--perf-no_write_workqueue"
                      ];
                      settings.allowDiscards = true;
                      # LUKS passphrase will be prompted interactively only
                      type = "luks";
                      name = "cryptroot";
                      content = {
                        type = "zfs";
                        pool = "zroot";
                      };
                    };
                  }
                else
                  {
                    content = {
                      type = "zfs";
                      pool = "zroot";
                    };
                  }
              )
            ];
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
        datasets = mkMerge [
          {
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
          }
          (mkIf cfg.root.impermanence.enable {
            persist = {
              type = "zfs_fs";
              mountpoint = "/nix/persist";
              options."com.sun:auto-snapshot" = "true";
            };
          })
        ];
      };
    };
  };
}
