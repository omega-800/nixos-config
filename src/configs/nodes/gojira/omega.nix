{ lib, pkgs, ... }:
{
  config.c = {
    net = {
      id = 12;
      #network = [
      #  10
      #  0
      #  0
      #];
      pubkeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1wvPYjUK/HR8jsusm1m5rAmD9Ds0rqzMs9wmtYoWG2 omega@gojira"
      ];
    };
    sys = {
      profile = [ "school" ];
      system = "x86_64-linux";
      genericLinux = false;
      paranoid = lib.mkForce false;
      hardened = lib.mkForce false;
      stable = lib.mkForce false;
    };
    usr = {
      shell = pkgs.zsh;
      theme = "weeb";
      wm = "river";
      term = "kitty";
      minimal = false;
      extraBloat = true;
      termColors = {
        c1 = "35";
        c2 = "94";
      };
    };
  };
}
