{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "pixie";
      profile = "serv";
      system = "aarch64-linux";
      bootMode = "ext";
      genericLinux = false;
      paranoid = true;
    };
    usr = {
      shell = pkgs.zsh;
      extraBloat = false;
      theme = "gruvbox-dark-hard";
      style = true;
      #style = false;
      minimal = true;
    };
  };
}
