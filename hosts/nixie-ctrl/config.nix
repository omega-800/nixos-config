{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "nixie-ctrl";
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = false;
	bootMode = "bios";
    };
    usr = {
      wm = "dwm";
      shell = pkgs.zsh;
      term = "kitty";
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      #theme = "catppuccin-mocha";
    };
  };
}
