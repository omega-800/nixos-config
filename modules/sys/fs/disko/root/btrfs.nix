{ config, lib, ... }:
let cfg = config.m.fs.disko;
in {
  config = lib.mkIf (cfg.enable && cfg.root.type == "btrfs") {
    boot.initrd = lib.mkIf cfg.root.impermanence.enable {
      #TODO:
      # finish
      # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
      # do i even need this if i have root as tmpfs?
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
        # btrfs subvolume snapshot /mnt/root-blank /mnt/root
        btrfs subvolume create /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
      /* postDeviceCommands = lib.mkAfter ''
              mkdir /btrfs_tmp
              mount /dev/mapper/cryptroot /btrfs_tmp
              if [[ -e /btrfs_tmp/root ]]; then
                  mkdir -p /btrfs_tmp/old_roots
                  timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
                  mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
              fi

              delete_subvolume_recursively() {
                  IFS=$'\n'
                  for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                      delete_subvolume_recursively "/btrfs_tmp/$i"
                  done
                  btrfs subvolume delete "$1"
              }

              for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +7); do
                  delete_subvolume_recursively "$i"
              done

              btrfs subvolume create /btrfs_tmp/root
              umount /btrfs_tmp
            '';
      */
    };

    disko.devices.disk.root = {
      inherit (cfg.root) device;
      type = "disk";
      /* # idk if this works as expected
          postCreateHook = ''
           btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
         '';
      */
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
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [ "subvol=log" "compress=zstd" ];
                };
                "/persist" = {
                  mountpoint = "/nix/persist";
                  mountOptions = [ "subvol=persist" "compress=zstd" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
