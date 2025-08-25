{ config, lib, ... }:
let
  cfg = config.m.fs.dirs;
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkMerge
    ;
  inherit (lib.types)
    listOf
    submodule
    str
    nullOr
    ;
in
{
  options.m.fs.dirs = {
    enable = mkEnableOption "creation of directories";
    extraDirs = mkOption {
      type = listOf (submodule {
        options = {
          path = mkOption {
            type = str;
            description = "path";
          };
          group = mkOption {
            type = nullOr str;
            default = "root";
            description = "group";
          };
          mode = mkOption {
            type = nullOr str;
            default = "0640";
            description = "mode";
          };
          user = mkOption {
            type = nullOr str;
            default = "root";
            description = "user";
          };
        };
      });
      default = [ ];
      description = "extra dirs to be created";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.settings."mk-dirs" = mkMerge (
      map (dir: {
        "${dir.path}".d = {
          inherit (dir) group mode user;
        };
      }) cfg.extraDirs
    );
  };
}
