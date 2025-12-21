{ pkgs, ... }:
{
  config.c = {
    net.pubkeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFAWLgOdIuSkQ/oqgCS424xPL1rHXH88/EtWk/bYuw9e omega@fugazi"
    ];
    sys = {
      profile = ["school" "gaymer"];
      system = "x86_64-linux";
      genericLinux = false;
      stable = false;
      hardened = false;
      flavors = [
        "developer"
        "master"
      ];
    };
    usr = {
      # wm = "mango";
      wm = "river";
      shell = pkgs.zsh;
      term = "kitty";
      extraBloat = false;
      minimal = false;
      theme = "weeb";
      termColors = {
        c1 = "36";
        c2 = "35";
      };
    };
  };
}
