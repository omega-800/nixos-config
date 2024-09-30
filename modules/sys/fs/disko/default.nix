{ inputs, lib, pkgs, config, ... }:
let
  # disko
  disko = pkgs.writeShellScriptBin "disko" "${config.system.build.diskoScript}";
  disko-mount =
    pkgs.writeShellScriptBin "disko-mount" "${config.system.build.mountScript}";
  disko-format = pkgs.writeShellScriptBin "disko-format"
    "${config.system.build.formatScript}";
  cfg = config.m.fs.disko;
in
{
  imports =
    [ inputs.disko.nixosModules.disko ./pools-zfs.nix ./root-btrfs.nix ];
  options.m.fs.disko =
    let
      inherit (lib) mkOption types;
      fsTypes = lib.my.dirs.listNixModuleNames ../types;
      poolOpts = types.submodule {
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
          keylocation = mkOption {
            type = types.nonEmptyStr;
            default = "file://${config.sops.secrets."hosts/default/disk".path}";
            description = "path to encryption key";
          };
        };
      };
    in
    {
      enable = mkOption {
        type = types.bool;
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
    sops.secrets."hosts/default/disk" = { };
    # we don't want to generate filesystem entries on this image only if it should be flashed as an iso
    # disko.enableConfig =  false;
    disko.enableConfig = lib.mkDefault cfg.enable;

    # add disko commands to format and mount disks
    environment.systemPackages =
      if cfg.enable then [ disko disko-mount disko-format ] else [ ];
  };
}
