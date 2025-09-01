{ pkgs, ... }:
{
  config.c = {
    net.id = 69;
    sys = {
      profile = "pers";
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
      wm = "dwm";
      shell = pkgs.zsh;
      term = "kitty";
      extraBloat = false;
      theme = "thinkpad";
      termColors = {
        c1 = "31";
        c2 = "95";
      };
    };
  };
}
