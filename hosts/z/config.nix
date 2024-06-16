{ ... }: {
  config.c = {
    sys = {
      hostname = "z";
      profile = "work";
      system = "x86_64-linux";
      genericLinux = false;
    };
    usr = {
      devName = "gs2";
      devEmail = "georgiy.shevoroshkin@inteco.ch";
      wm = "dwm";
    };
  };
}
