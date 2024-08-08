{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "archie-925";
      profile = "work";
      system = "x86_64-linux";
      genericLinux = true;
    };
    usr = {
      devName = "gs2";
      devEmail = "georgiy.shevoroshkin@inteco.ch";
      wm = "dwm";
      shell = pkgs.zsh;
      extraBloat = true;
      theme = "catppuccin-mocha";
    };
  };
}
