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
      pubkeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF1wvPYjUK/HR8jsusm1m5rAmD9Ds0rqzMs9wmtYoWG2 omega@gojira" ];
    };
    sys = {
      profile = "pers";
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
      minimal = true;
      wm = "sway";
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      termColors = {
        c1 = "35";
        c2 = "90";
      };
    };
  };
}
