{ lib, pkgs, ... }:
{
  config.c = {
    net = {
      id = 12;
      network = [
        10
        0
        0
      ];
    };
    sys = {
      profile = ["serv"];
      system = "x86_64-linux";
      genericLinux = false;
      paranoid = lib.mkForce false;
      # FIXME: ah hell where did i fuck up 
      hardened = lib.mkForce false;
      # FIXME: incompatibilities with some pkgs, i forgot
      stable = lib.mkForce false;
      # stable = lib.mkForce true;
      flavors = [
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
