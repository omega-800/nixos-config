{ usr, lib, config, pkgs, ... }: 
with lib;
let cfg = config.u.utils;
in {
  options.u.utils = {
    enable = mkEnableOption "enables essential packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      iproute2
      iputils
      curl
      wget
      which
      less
      htop-vim
      ripgrep
      bc
    ] ++ (if !usr.minimal then [
      stow
      xclip
      xbindkeys
      brightnessctl
      bind
    ] else []) ++ (if usr.extraBloat then [
      freecad
      vulnix
      thefuck
      screenkey
      cloc
      gnused
      xdg-ninja
      translate-shell
      lynis
    ] else []);
  };
}
