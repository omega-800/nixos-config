{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.utils;
in {
  options.u.utils = {
    enable = mkEnableOption "enables essential packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vulnix
      iproute2
      iputils
      gzip
      xz
      which
      cloc
      gnused
      less
      unzip
      bc
      stow
      xdg-ninja
      xclip
      xbindkeys
      ripgrep
      curl
      wget
      htop
      flameshot
      screenkey
      lynis
    ];
  };
}
