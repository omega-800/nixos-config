{ lib, config, ... }: {
  options.m.fs.disko.pools = let
    inherit (lib) mkOption types;
    poolOpts = types.submodule {
      options = {
        type = mkOption {
          type = types.enum (lib.omega.dirs.listNixModuleNames ./.);
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
  in mkOption {
    type = types.nullOr (types.attrsOf poolOpts);
    default = null;
    description = "extra pools (will always persist)";
  };
  imports = [ ./zfs.nix ];
  config.sops.secrets."hosts/default/disk" = { };
}
