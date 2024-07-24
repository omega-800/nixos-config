{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "nixie";
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = false;
    };
    usr = {
      wm = "dwm";
      shell = pkgs.zsh;
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      #theme = "catppuccin-mocha";
    };
  };
}
