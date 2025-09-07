{ pkgs, ... }:
{
  config.c = {
    net.id = 69;
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
      # wm = "dwm";
      wm = "sway";
      shell = pkgs.zsh;
      term = "kitty";
      extraBloat = true;
      theme = "thinkpad";
      termColors = {
        c1 = "31";
        c2 = "95";
      };
    };
  };
}
