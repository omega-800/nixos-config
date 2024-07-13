{ pkgs, ... }: {
  config.c = {
    sys = {
      hostname = "custom-view";
      profile = "serv";
      system = "x86_64-linux";
      genericLinux = true;
    };
    usr = {
      devName = "";
      devEmail = "";
      wm = "";
      shell = pkgs.zsh;
      extraBloat = false;
    };
  };
}
