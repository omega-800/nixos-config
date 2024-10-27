# https://github.com/nix-community/disko-templates/blob/main/single-ext4-luks-and-double-zfs-mirror/disko-config.nix
{ lib, config, ... }:
let
  cfg = config.m.fs.disko;
  inherit (lib) omega mkIf attrsToList imap mkMerge;
in {
  config = mkIf (cfg.enable && omega.misc.poolsContainFs "zfs" cfg) {
    disko.devices = let
      inherit (cfg) pools;
      zfsPools = builtins.filter (p: p.value.type == "zfs") (attrsToList pools);
    in {
      disk = omega.attrs.flatMapToAttrs (p:
        imap (i: device: {
          "${p.name}${toString i}" = {
            inherit device;
            type = "disk";
            content = {
              type = "gpt";
              partitions.zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "${p.name}";
                };
              };
            };
          };
        }) p.value.devices) zfsPools;
      zpool = mkMerge (map (p: {
        "${p.name}" = {
          type = "zpool";
          mode = let nDisks = builtins.length p.value.devices;
          in if p.value.stripe then
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
            "zfs list -t snapshot -H -o name | grep -E '^${p.name}@blank$' || zfs snapshot ${p.name}@blank";
          datasets."crypt${p.name}" = {
            type = "zfs_fs";
            mountpoint = "/${p.name}";
            options = {
              inherit (p.value) keylocation;
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
            };
            # use this to read the key during boot
            postCreateHook = ''
              zfs set keylocation="prompt" "${p.name}/cryptstore";
            '';
          };
        };
      }) zfsPools);
    };
  };
}
