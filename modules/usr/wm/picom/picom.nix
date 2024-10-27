{ config
, usr
, pkgs
, lib
, ...
}:

with lib;
let
  inherit (pkgs) nixGL;
in
# nixGL = import ../../nixGL/nixGL.nix { inherit config pkgs; };
{
  home = {
    packages = with pkgs; [ (nixGL picom) ];
    file.".config/picom/picom.conf".source = if usr.wm == "dwm" then ./picom_dwm.conf else ./picom.conf;
  };
}
