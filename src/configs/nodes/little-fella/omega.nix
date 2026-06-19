{ lib, pkgs, ... }:
{
  config.c = {
    net.id = 49;
    sys = {
      profile = ["serv"];
      system = "x86_64-linux";
      genericLinux = false;
      flavors = [
        "storer"
        "slave"
      ];
    };
    usr = {
      shell = pkgs.zsh;
      theme = "gruvbox-dark-hard";
      style = lib.mkForce true;
      termColors = {
        c1 = "33";
        c2 = "32";
      };
    };
  };
}
