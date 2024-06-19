{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.mysql;
in {
  options.m.mysql = {
    enable = mkEnableOption "enables mysql";
  };

  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      initialScript = ./mysql_setup.sql;
    };
    services.gnome.gnome-keyring.enable = true;
};
}
