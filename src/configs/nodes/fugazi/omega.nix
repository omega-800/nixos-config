{ pkgs, ... }:
{
  config.c = {
    sys = {
      profile = "pers";
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
      theme = "weeb";
      termColors = {
        c1 = "36";
        c2 = "35";
      };
    };
  };
}
