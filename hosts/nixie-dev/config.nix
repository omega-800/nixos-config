{ lib, pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "nixie-dev";
      profile = "serv";
      bootMode = "bios";
      system = "x86_64-linux";
      genericLinux = false;
      paranoid = lib.mkForce false;
    };
    usr = {
      shell = pkgs.zsh;
      theme = "gruvbox-dark-hard";
      style = lib.mkForce true;
      termColors = {
        c1 = "34";
        c2 = "37";
      };
    };
  };
}
