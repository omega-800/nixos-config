{ lib, config, pkgs, ... }: 
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
      curl
      wget
      gzip
      xz
      unzip
      which
      cloc
      gnused
      ripgrep
      less
      bc
      stow
      xdg-ninja
      xclip
      xbindkeys
      htop-vim
      flameshot
      screenkey
      lynis
      brightnessctl
      thefuck
      bind
      translate-shell
    ];
  };
}
