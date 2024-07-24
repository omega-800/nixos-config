{ lib, config, pkgs, usr, ... }: {
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = builtins.fetchGit {
        url = "https://github.com/omega-800/dwm.git"; 
        ref = "main";
        rev = "8f08ba04505ffa904f6d1869f2cd606f677df48f";
      };
#      patches = [
#        (pkgs.fetchpatch {
#          url = "https://dwm.suckless.org/patches/activetagindicatorbar/dwm-activetagindicatorbar-6.2.diff";
#          hash = "sha256-sSuNd3wusT9AKHHthr1gpAN3gbmd5KCXSf3FsXx6dDk=";
#        })
#        (pkgs.fetchpatch {
#          url = "https://dwm.suckless.org/patches/bottomstack/dwm-bottomstack-20160719-56a31dc.diff";
#          hash = "sha256-ogOWuQm3SU7YhX6DTt08WQUtnYrffrJWMdCcmrphnEM=";
#        })
#        ./patches/mine.diff
#      ];
    };
  };
}
