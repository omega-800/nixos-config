{ pkgs, lib, ... }:
{
  config.c = {
    net = {
      id = 10;
      network = [
        10
        100
        0
      ];
      domain = "dmz.home.lan";
    };
    sys = {
      profile = "serv";
      system = "aarch64-linux";
      genericLinux = false;
      #paranoid = true;
      paranoid = lib.mkForce false;
    };
    usr = {
      shell = pkgs.zsh;
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      style = false;
      minimal = true;
      termColors = {
        c1 = "31";
        c2 = "96";
      };
    };
  };
}
