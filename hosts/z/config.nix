{ ... }: {
  config.c = {
    sys = {
      hostname = "z"; # hostname
      profile = "work"; # select a profile defined from my profiles directory
      system = "x86_64-linux"; # system arch
      genericLinux = false;
    };
    usr = {
      devName = "gs2";
      devEmail = "georgiy.shevoroshkin@inteco.ch";
    };
  };
}
