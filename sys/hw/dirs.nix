{ config, lib, ... }:
with lib;
let cfg = config.m.dirs;
in {
  options.m.dirs = {
    enable = mkEnableOption "enables creation of directories";
    extraDirs = with types;
      mkOption {
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
    systemd.tmpfiles.settings."mk-dirs" = mkMerge
      (map (dir: { "${dir.path}".d = { inherit (dir) group mode user; }; })
        cfg.extraDirs);
  };
}
