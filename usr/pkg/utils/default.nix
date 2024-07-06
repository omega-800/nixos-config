{ lib, pkgs, usr, ... }:
let swhkd = (pkgs.callPackage ./swhkd.nix { });
in {
  imports = [
    ./utils.nix
    ./sxhkd.nix
    ./dunst.nix
    ./rofi.nix
    ./fzf.nix
    ./fetch.nix
    ./clipmenu.nix
    ./sxhkd.nix
  ];
  home.packages = lib.mkIf (usr.wmType == "wayland") [ swhkd ];
}
