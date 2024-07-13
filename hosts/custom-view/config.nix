{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "custom-view";
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
