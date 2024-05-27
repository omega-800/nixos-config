{ lib, config, ... }: {
  imports = [ ../x11/x11.nix ];
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
