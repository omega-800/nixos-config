{ lib, config, ... }: {
  imports = [ ../x11/x11.nix ];
  services.xserver = {
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.override {
        src = /home/${userSettings.username}/.config/dwm;
      };
    };
  };
}                   }
