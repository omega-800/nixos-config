{ lib, config, pkgs, ... }: 
with lib;
let 
  cfg = config.u.user;
  nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
in {
  options.u.user = {
    enable = mkEnableOption "enables userspace packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #starship
      pass
      tree-sitter
      rofi
      feh
      maim
      fortune 
      cowsay 
      lolcat
      (nixGL alacritty)
    ];
  };
}
