{ lib, ... }: {
  options.m.fs.disko.root = {
    device = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "/dev/sda";
      description = "root device";
    };
    type = lib.mkOption {
      type = lib.types.enum (lib.my.dirs.listNixModuleNames ./.);
      default = "btrfs";
      description = "root fs type";
    };
  };
  imports = [ ./zfs.nix ./btrfs.nix ./parts ];
}
