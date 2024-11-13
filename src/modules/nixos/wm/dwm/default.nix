{
  inputs,
  config,
  sys,
  lib,
  pkgs,
  usr,
  ...
}:
let
  cfg = config.m.wm.dwm;
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    ;
in
{
  options.m.wm.dwm = {
    enable = mkOption {
      description = "enables dwm";
      type = types.bool;
      default = usr.wm == "dwm";
    };
  };
  config = mkIf cfg.enable {
    services.xserver.windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = inputs.omega-dwm;
        # src = builtins.fetchGit {
        #   url = "https://github.com/omega-800/dwm.git"; 
        #   ref = "main";
        #   rev = "bfa4bcd732cdb4d4eb8448dafc83bb0ce3c7e3f4";
        # };
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
  };
}
