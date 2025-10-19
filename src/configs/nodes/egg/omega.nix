{ lib, pkgs, ... }:
{
  config.c = {
    net = {
      id = 122;
      network = [
        10
        0
        0
      ];
    };
    sys = {
      profile = "serv";
      system = "x86_64-linux";
      genericLinux = false;
      paranoid = lib.mkForce false;
      flavors = [
        "storer"
        "hoster"
        "slave"
      ];
    };
    usr = {
      shell = pkgs.zsh;
      theme = "gruvbox-dark-hard";
      termColors = {
        c1 = "35";
        c2 = "90";
      };
    };
  };
}
