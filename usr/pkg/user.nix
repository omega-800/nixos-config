{ lib, config, pkgs, home, ... }: 
with lib;
let cfg = config.u.user;
in {
  options.u.user = {
    enable = mkEnableOption "enables userspace packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      alacritty
      pass
      neovim
      uwufetch
      fastfetch
      rofi
      feh
      maim
      fortune 
      cowsay 
      lolcat
    ];
  };
}
