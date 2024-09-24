# https://github.com/nix-community/disko-templates/blob/main/single-ext4-luks-and-double-zfs-mirror/disko-config.nix

# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#   imports = [ ./disko-config.nix ];
#   disko.devices.disk.dataN.device = "/dev/sdb";
# }

 {
  disko.devices = let stripe = false; nDisks = 2; keylocation = "file:///tmp/secret.key"
; name = "store"; lib = (import <nixpkgs> { }).lib ; in{
    disk = {data1= {
      type = "disk";
device = "/dev/sdb";
      content = {
        type = "gpt";
        partitions.zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "${name}";
          };
        };
      };
    };data2= {
      type = "disk";
device = "/dev/sdc";
      content = {
        type = "gpt";
        partitions.zfs = {
          size = "100%";
          content = {
            type = "zfs";
            pool = "${name}";
          };
        };
      };
    };} //
{root = {
    type = "disk";
device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
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
            mountpoint = "/boot";
            mountOptions = [ "defaults" ];
          };
        };
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
  };}
;
    zpool."${name}" = {
      type = "zpool";
      mode = if stripe then
        ""
      else if nDisks >= 10 then
        "raidz3"
      else if nDisks >= 6 then
        "raidz2"
      else if nDisks >= 3 then
        "raidz1"
      else if nDisks >= 2 then
        "mirror"
      else
        "";
      options.cachefile = "none";
      rootFsOptions = {
        compression = "zstd";
        "com.sun:auto-snapshot" = "true";
      };
      postCreateHook =
        "zfs list -t snapshot -H -o name | grep -E '^${name}@blank$' || zfs snapshot ${name}@blank";

      datasets."cryptstore" = {
        type = "zfs_fs";
        mountpoint = "/${name}";
        options = {
          inherit keylocation;
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
        };
        # use this to read the key during boot
        postCreateHook = ''
          zfs set keylocation="prompt" "${name}/cryptstore";
        '';
      };
    };
  };
}
