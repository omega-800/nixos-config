{ ... }: {
  config.c = {
    sys = {
      hostname = "archie";
      profile = "pers";
      system = "x86_64-linux";
      genericLinux = true;
    };
    usr = {
      devName = "omega-800";
      devEmail = "gshevoroshkin@gmail.com";
      wm = "dwm";
    };
  };
}
