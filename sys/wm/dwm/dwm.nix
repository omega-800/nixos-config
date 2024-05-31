{ lib, config, pkgs, userSettings, ... }: {
  imports = [ ../x11/x11.nix ];
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
       src = ./src;
#      patches = [
#        (pkgs.fetchpatch {
#          url = "https://dwm.suckless.org/patches/activetagindicatorbar/dwm-activetagindicatorbar-6.2.diff";
#          hash = "sha256-sSuNd3wusT9AKHHthr1gpAN3gbmd5KCXSf3FsXx6dDk=";
#        })
#        (pkgs.fetchpatch {
#          url = "https://dwm.suckless.org/patches/bottomstack/dwm-bottomstack-20160719-56a31dc.diff";
#          hash = "sha256-ogOWuQm3SU7YhX6DTt08WQUtnYrffrJWMdCcmrphnEM=";
#        })
#        ./mine.diff
#      ];
    };
  };
}
