{ pkgs, ... }:
{
  config.c = {
    net = {
      id = 25;
      pubkeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF28oxG+EVTVwLKw3f+9+qnrY08wbJjnLqyBsOqKNt3O omega@archie-925"
      ];
    };
    sys = {
      profile = "work";
      system = "x86_64-linux";
      genericLinux = true;
    };
    usr = {
      term = "kitty";
      devName = "gs2";
      devEmail = "georgiy.shevoroshkin@inteco.ch";
      wm = "dwm";
      # wm = "sway";
      shell = pkgs.zsh;
      extraBloat = true;
      theme = "ayu-dark";
      termColors = {
        c1 = "35";
        c2 = "91";
      };
    };
  };
}
