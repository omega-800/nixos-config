{ config, lib, ... }:
let cfg = config.m.fs.disko;
in {
  imports = [ ./parts ];
  config = lib.mkIf (cfg.enable && cfg.root.type == "zfs") {
    disko.devices = {
      disk.root = {
        inherit (cfg.root) device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            swap = {
              start = "-8GiB";
              end = "-0";
              type = "8200";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              size = "100%";
              label = "luks";
              content = {
                # LUKS passphrase will be prompted interactively only
                type = "luks";
                name = "cryptroot";
                extraOpenArgs =
                  [ "--perf-no_read_workqueue" "--perf-no_write_workqueue" ];
                settings = { allowDiscards = true; };
                content = {
                  type = "btrfs";
                  extraArgs = [ "-L" "nixos" "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [ "subvol=root" "compress=zstd" ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [ "subvol=home" "compress=zstd" ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                    };
                    "/persist" = {
                      mountpoint = "/persist";
                      mountOptions = [ "subvol=persist" "compress=zstd" ];
                    };
                    "/log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "subvol=log" "compress=zstd" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
    fileSystems = {
      "/persist".neededForBoot = true;
      "/var/log".neededForBoot = true;
    };
  };
}
