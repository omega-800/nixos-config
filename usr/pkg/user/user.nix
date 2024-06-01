{ lib, config, pkgs, home, systemSettings, ... }: 
with lib;
let cfg = config.u.user;
in {
  options.u.user = {
    enable = mkEnableOption "enables userspace packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #starship
      #uwufetch
      pass
      tree-sitter
      fastfetch
      rofi
      feh
      maim
      fortune 
      cowsay 
      lolcat
    ] ++ (if systemSettings.genericLinux then [] else [
      alacritty
    ]);
  };
}
