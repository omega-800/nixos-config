{ lib, config, pkgs, usr, ... }: {
  imports = [ ../x11/x11.nix ];
  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = builtins.fetchGit {
        url = "https://github.com/omega-800/dwm.git"; 
        ref = "main";
        rev = "ca6bb2a6860d94e71ba33df97db4abfd844a4028";
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
