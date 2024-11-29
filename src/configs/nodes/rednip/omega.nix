{ pkgs, ... }:
{
  config.c = {
    net = {
      id = 69;
    };
    sys = {
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = false;
      stable = false;
      flavors = [
        "developer"
        "master"
      ];
    };
    usr = {
      wm = "sway";
      shell = pkgs.zsh;
      term = "kitty";
      extraBloat = false;
      theme = "god";
      termColors = {
        c1 = "31";
        c2 = "95";
      };
    };
  };
}
