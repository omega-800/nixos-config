{ lib, pkgs, ... }: {
  config.c = {
    sys = {
      profile = "serv";
      system = "x86_64-linux";
      genericLinux = false;
      paranoid = lib.mkForce false;
      flavors = [ "master" "child" "developer" "builder" ];
    };
    usr = {
      shell = pkgs.zsh;
      theme = "gruvbox-dark-hard";
      #style = lib.mkForce true;
      termColors = {
        c1 = "34";
        c2 = "37";
      };
    };
  };
}
