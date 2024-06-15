{ config, pkgs, lib, ... }:

{
  config = lib.mkIf (!config.c.sys.genericLinux) {
    home.packages = with pkgs; [ picom ];

    home.file.".config/picom/picom.conf".source = if config.c.usr.wm == "dwm" then ./picom_dwm.conf else ./picom.conf;
  };
}
