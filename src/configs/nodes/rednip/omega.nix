{ pkgs, ... }:
{
  config.c = {
    net = {
      id = 69;
      pubkeys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzbzskHnyrgboFGE/+ldf1nW5y8Bglzj6/RvepTuJQK omega@rednip"];
    };
    sys = {
      profile = "school";
      system = "x86_64-linux";
      genericLinux = false;
      stable = false;
      # FIXME: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhh
      hardened = false;
      flavors = [
        "developer"
        "master"
      ];
    };
    usr = {
      devName = "omega";
      devEmail = "georgiy.shevoroshkin@ost.ch";
      wm = "dwm";
      shell = pkgs.zsh;
      term = "st";
      # term = "kitty";
      extraBloat = true;
      theme = "thinkpad";
      termColors = {
        c1 = "31";
        c2 = "95";
      };
    };
  };
}
