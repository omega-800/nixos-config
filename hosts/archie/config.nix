{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "archie";
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = true;
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
