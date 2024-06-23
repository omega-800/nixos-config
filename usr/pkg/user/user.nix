{ usr, lib, config, pkgs, ... }: 
with lib;
let 
  cfg = config.u.user;
in {
  options.u.user = {
    enable = mkEnableOption "enables userspace packages";
  };
 
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #starship
      pass
      tree-sitter
      feh
      maim
    ] ++ (if usr.extraBloat then [
      fortune 
      cowsay 
      lolcat
    ] else []);
  };
}
