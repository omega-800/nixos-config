{ config, usr, pkgs, lib, ... }:

with lib;
let nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
in {
  home.packages = with pkgs; [ (nixGL picom) ];
  home.file.".config/picom/picom.conf".source =
    if usr.wm == "dwm" then ./picom_dwm.conf else ./picom.conf;
}
