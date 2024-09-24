# https://github.com/nix-community/disko-templates/blob/main/single-ext4-luks-and-double-zfs-mirror/disko-config.nix

# USAGE in your configuration.nix.
# Update devices to match your hardware.
# {
#   imports = [ ./disko-config.nix ];
#   disko.devices.disk.dataN.device = "/dev/sdb";
# }

{ stripe ? false, nDisks ? 2, keylocation ? "file:///tmp/secret.key"
, name ? "store", lib ? (import <nixpkgs> { }).lib }: {
  disko.devices = {
    disk = builtins.listToAttrs (lib.imap (i: v: {
      name = "data${toString i}";
      value = v;
    }) (lib.replicate nDisks {
      type = "disk";
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
    }));
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
