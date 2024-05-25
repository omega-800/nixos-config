{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.utils;
in {
  options.u.utils = {
    enable = mkEnableOption "enables essential packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unzip
      bc
      stow
      xdg-ninja
      xclip
      keyd
      xbindkeys
      ripgrep
      fzf
      curl
      wget
      htop
      nvim
    ];
  };
}
