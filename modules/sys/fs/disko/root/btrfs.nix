{ config, lib, ... }:
let cfg = config.m.fs.disko;
in {
  config = lib.mkIf (cfg.enable && cfg.root.type == "btrfs") {
    boot.initrd = lib.mkIf cfg.root.impermanence.enable {
      #TODO:
      # finish
      # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
      # We then take an empty *readonly* snapshot of the root subvolume,
      # which we'll eventually rollback to on every boot.
      # btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
      postDeviceCommands = lib.mkBefore ''
        mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ /dev/mapper/cryptroot /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines
        #
        # I suspect these are related to systemd-nspawn, but
        # since I don't use it I'm not 100% sure.
        # Anyhow, deleting these subvolumes hasn't resulted
        # in any issues so far, except for fairly
        # benign-looking errors from systemd-tmpfiles.
        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
      systemd.tmpfiles.settings."mk-persistent-dirs" = { };
    };
    disko.devices.disk.root = {
      inherit (cfg.root) device;
      type = "disk";
      content = {
        type = "gpt";
        partitions.root = {
          size = "100%";
          label = "luks";
          content = {
            # LUKS passphrase will be prompted interactively only
            type = "luks";
            name = "cryptroot";
            extraOpenArgs =
              [ "--perf-no_read_workqueue" "--perf-no_write_workqueue" ];
            settings.allowDiscards = true;
            content = {
              type = "btrfs";
              extraArgs = [ "-L" "nixos" "-f" ];
              subvolumes = lib.mkMerge [
                (lib.mkIf (!cfg.root.impermanence.enable) {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "defaults"
                      "nodev"
                      "nosuid"
                      "noexec"
                      "relatime"
                      "subvol=root"
                      "compress=zstd"
                    ];
                  };
                })
                {
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "nodev"
                      "nosuid"
                      "nouser" # limit? "exec"
                      "auto"
                      "async"
                      "usrquota"
                      "grpqouta"
                      "rw"
                      "subvol=home"
                      "compress=zstd"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "defaults"
                      "nodev"
                      "nosuid"
                      "nouser"
                      "subvol=nix"
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/usr" = {
                    mountpoint = "/usr";
                    mountOptions = [
                      "defaults"
                      "nodev"
                      "errors=remount-ro"
                      "subvol=usr"
                      "compress=zstd"
                    ];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "defaults"
                      "nodev"
                      "noexec"
                      "nosuid"
                      "nouser"
                      "rw"
                      "subvol=log"
                      "compress=zstd"
                    ];
                  };
                  "/persist" = {
                    mountpoint = "/nix/persist";
                    mountOptions = [ "subvol=persist" "compress=zstd" ];
                  };
                }
              ];
            };
          };
        };
      };
    };
  };
}
