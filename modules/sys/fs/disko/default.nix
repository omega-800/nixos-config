{ inputs, lib, pkgs, config, ... }:
let
  # disko
  disko = pkgs.writeShellScriptBin "disko" "${config.system.build.disko}";
  disko-mount =
    pkgs.writeShellScriptBin "disko-mount" "${config.system.build.mountScript}";
  disko-format = pkgs.writeShellScriptBin "disko-format"
    "${config.system.build.formatScript}";
in
{
  imports =
    [ inputs.disko.nixosModules.disko ./pools-zfs.nix ./root-btrfs.nix ];
  options.m.fs.disko =
    let
      inherit (lib) mkOption types;
      fsTypes = lib.my.dirs.listNixModuleNames ../types;
      poolOpts = types.submodule {
        description = "pool fs type";
        options = {
          type = mkOption {
            type = types.enum fsTypes;
            default = "zfs";
            description = "pool fs type";
          };
          stripe = mkOption {
            type = types.bool;
            default = false;
            description = "whether to stripe data";
          };
          devices = mkOption {
            type = types.listOf types.nonEmptyStr;
            default = [ "/change/me" ];
            description = "list of devices to use for the pool";
          };
          keylocation = {
            type = types.nonEmptyStr;
            default = "file://${config.sops.secrets."hosts/default/disk".path}";
            description = "path to encryption key";
          };
        };
      };
    in
    {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "enables disko";
      };
      root = {
        device = mkOption {
          type = types.nonEmptyStr;
          default = "/dev/sda";
          description = "root device";
        };
        type = mkOption {
          type = types.enum fsTypes;
          default = "btrfs";
          description = "root fs type";
        };
      };
      pools = mkOption {
        type = types.nullOr (types.attrsOf poolOpts);
        default = null;
        description = "extra pools";
      };
    };
  config = {
    # we don't want to generate filesystem entries on this image only if it should be flashed as an iso
    # disko.enableConfig =  false;
    disko.enableConfig = lib.mkDefault true;

    # add disko commands to format and mount disks
    environment.systemPackages = [ disko disko-mount disko-format ];
  };
}
