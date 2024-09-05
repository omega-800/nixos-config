{ pkgs, ... }: {
  config.c = {
    sys = {
      profile = "serv";
      system = "x86_64-linux";
      genericLinux = true;
    };
    usr = {
      style = true;
      username = "dev";
      devName = "";
      devEmail = "";
      wm = "";
      shell = pkgs.zsh;
      extraBloat = false;
      minimal = true;
    };
  };
}
