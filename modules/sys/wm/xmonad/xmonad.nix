{ lib, config, ... }: {
  services.xserver = {
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
    displayManager = {
      defaultSession = "none+xmonad";
    };
  };
};
                      }
