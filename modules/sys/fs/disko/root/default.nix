{ lib, sys, ... }: {
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
    impermanent = lib.mkOption {
      type = lib.types.bool;
      default = sys.hardened;
      description = "if fs should be impermanent";
    };
    persistVols = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "home" "var/log" "etc/nixos" ];
      description = "volumes which should persist after reboot";
    };
  };
  imports = [ ./zfs.nix ./btrfs.nix ];
}
