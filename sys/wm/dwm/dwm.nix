{ lib, config, pkgs, userSettings, ... }: {
  imports = [ ../x11/x11.nix ];
  services.xserver = {
    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = /home/${userSettings.username}/.config/dwm;
      };
    };
  };
}
