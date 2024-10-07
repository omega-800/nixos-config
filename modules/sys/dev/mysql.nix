{ lib, config, pkgs, usr, sys, ... }:
with lib;
let cfg = config.m.dev.mysql;
in {
  options.m.dev.mysql.enable = mkOption {
    description = "enables mysql";
    type = types.bool;
    default = config.m.dev.enable;
  };

  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      initialScript = mkIf (!sys.hardened)
        (pkgs.writeShellScript "mysql-setup" ''
          CREATE USER '${usr.username}'@'localhost';
          GRANT ALL PRIVILEGES ON *.* TO '${usr.username}'@'localhost';
        '');
    };
  };
}
