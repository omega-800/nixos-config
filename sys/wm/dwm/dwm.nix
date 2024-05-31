{ lib, config, pkgs, userSettings, ... }: {
  imports = [ ../x11/x11.nix ];
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      # src = /home/${userSettings.username}/dotfiles/configs/.config/dwm;
      patches = [
        ./mine.diff
        (pkgs.fetchpatch {
          url = "https://dwm.suckless.org/patches/activeindicatorbar/dwm-activeindicatorbar-6.2.diff";
          hash = "";
        })
      ];
    };
  };
}
