{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "nixie";
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = false;
      stable = false;
    };
    usr = {
      wm = "dwm";
      shell = pkgs.zsh;
      term = "kitty";
      extraBloat = true;
      theme = "gruvbox-dark-hard";
      #theme = "atom-dark";
      termColors = {
        c1 = "36";
        c2 = "35";
      };
    };
  };
}
