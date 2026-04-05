{ lib, pkgs, ... }:
{
  config.c = {
    net = {
      id = 12;
    };
    sys = {
      # profile = ["serv"];
      profile = [ "pers" ];
      system = "x86_64-linux";
      genericLinux = false;
      paranoid = lib.mkForce false;
      hardened = lib.mkForce false;
      stable = lib.mkForce false;
    };
    usr = {
      shell = pkgs.zsh;
      theme = "weeb";
      wm = "niri";
      termColors = {
        c1 = "35";
        c2 = "90";
      };
    };
  };
}
