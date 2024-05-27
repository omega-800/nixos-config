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
      starship
      pass
      neovim
      tree-sitter
      #uwufetch
      fastfetch
      rofi
      feh
      maim
      fortune 
      cowsay 
      lolcat
      dunst
    ];
  };
}
