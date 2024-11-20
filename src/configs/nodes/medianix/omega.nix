{ lib, pkgs, ... }:
{
  config.c = {
    net = {
      id = 121;
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
        "child"
        "storer"
        "hoster"
      ];
    };
    usr = {
      shell = pkgs.zsh;
      theme = "gruvbox-dark-hard";
      style = lib.mkForce true;
      termColors = {
        c1 = "35";
        c2 = "90";
      };
    };
  };
}
