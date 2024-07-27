{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "nixie";
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = false;
    };
    usr = {
      wm = "sway";
      shell = pkgs.zsh;
      term = "kitty";
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      #theme = "catppuccin-mocha";
    };
  };
}
