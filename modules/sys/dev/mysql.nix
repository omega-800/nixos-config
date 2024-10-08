{ lib, config, pkgs, usr, sys, ... }:
let
  cfg = config.m.dev.mysql;
  inherit (lib) mkEnableOption types mkIf;
in {
  options.m.dev.mysql.enable = mkEnableOption "enables mysql";

  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      initialScript = mkIf (sys.paranoia == 0)
        (pkgs.writeShellScript "mysql-setup" ''
          CREATE USER '${usr.username}'@'localhost';
          GRANT ALL PRIVILEGES ON *.* TO '${usr.username}'@'localhost';
        '');
    };
  };
}
