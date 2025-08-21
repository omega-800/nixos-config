{ lib, ... }@args:
let
  swap = import ./parts/swap.nix;
  boot = import ./parts/boot.nix args;
  all = swap // boot;
in
{
  options.m.fs.disko.root = {
    device = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "/dev/sda";
      description = "root device";
    };
    type = lib.mkOption {
      type = lib.types.enum (lib.omega.dirs.listNixModuleNames ./.);
      default = "btrfs";
      description = "root fs type";
    };
    # FIXME: doesn't work.. grub rescue> disk not found
    encrypt = lib.mkEnableOption "root disk encryption";
  };
  imports = [
    # FIXME: make this less shit. parts get overridden if parent disk is redefined
    (import ./zfs.nix all)
    (import ./btrfs.nix all)
    ./parts
  ];
}
