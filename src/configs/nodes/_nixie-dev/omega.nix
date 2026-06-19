{ lib, pkgs, ... }:
{
  config.c = {
    net = {
      id = 14;
      network = [
        10
        0
        0
      ];
      prefix = 24;
    };
    sys = {
      profile = "serv";
      system = "x86_64-linux";
      genericLinux = false;
      paranoid = lib.mkForce false;
      stable = lib.mkForce false;
      flavors = [
        "master"
        "child"
        "developer"
        "builder"
      ];
    };
    usr = {
      shell = pkgs.zsh;
      theme = "nord";
      style = lib.mkForce true;
      termColors = {
        c1 = "34";
        c2 = "37";
      };
    };
  };
}
