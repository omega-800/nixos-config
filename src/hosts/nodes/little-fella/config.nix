{ lib, pkgs, ... }:
{
  config.c = {
    sys = {
      profile = "serv";
      system = "x86_64-linux";
      genericLinux = false;
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
