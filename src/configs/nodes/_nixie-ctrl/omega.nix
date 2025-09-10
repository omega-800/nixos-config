{ pkgs, ... }:
{
  config.c = {
    sys = {
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = false;
    };
    usr = {
      wm = "dwm";
      shell = pkgs.zsh;
      term = "alacritty";
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      #theme = "catppuccin-mocha";
    };
  };
}
