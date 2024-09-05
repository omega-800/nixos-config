{ ... }: {
  config.c = {
    sys = {
      profile = "work";
      system = "x86_64-linux";
      genericLinux = true;
    };
    usr = {
      devName = "your-git-username";
      devEmail = "your-git-email";
      wm = "dwm";
    };
  };
}
