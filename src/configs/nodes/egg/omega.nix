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
pubkeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICuOJQevf59BvwPcTiKpm1vYJzuSk1Fm2p82KBEQx4WT omega@egg"];
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
