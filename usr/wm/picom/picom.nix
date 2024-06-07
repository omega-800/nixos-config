{ pkgs, lib, systemSettings, userSettings, ... }:

{
  config = lib.mkIf (!systemSettings.genericLinux) {
    home.packages = with pkgs; [ picom ];

    home.file.".config/picom/picom.conf".source = if userSettings.wm == "dwm" then ./picom_dwm.conf else ./picom.conf;
  };
}
