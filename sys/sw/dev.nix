{ config, lib, pkgs, ... }: {
  #config = lib.mkIf config.u.work.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      initialScript = ./mysql_setup.sql;
    };
    services.gnome.gnome-keyring.enable = true;
  #};
  programs.nix-ld.enable = true;
}
