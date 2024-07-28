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
    ] ++ (if !usr.minimal then [
      bc
      stow
      xclip
      xbindkeys
      brightnessctl
      bind
      freecad
    ] else []) ++ (if usr.extraBloat then [
      vulnix
      thefuck
      screenkey
      xz
      cloc
      gnused
      xdg-ninja
      translate-shell
      lynis
    ] else []);
  };
}
