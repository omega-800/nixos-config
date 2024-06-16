{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (!sys.genericLinux) {
    home.packages = with pkgs; [ picom ];

    home.file.".config/picom/picom.conf".source = if usr.wm == "dwm" then ./picom_dwm.conf else ./picom.conf;
  };
}
