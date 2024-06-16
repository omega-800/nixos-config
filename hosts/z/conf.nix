let 
conf = {
    sys = {
        bootMode = "uefi"; # uefi or bios
        genericLinux = false;
        hardened = true;
        paranoid = false;
    };
    usr = rec {
        username = "omega"; # username
        homeDir = "/home/${username}";
        # profile
        devName = "gs2";
        devEmail = "georgiy.shevoroshkin@inteco.ch"; 
        wm = "dwm"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
    };
  };
in
conf
