{ lib, pkgs, usr, ... }: 
let 
  swhkd = (pkgs.callPackage ./swhkd.nix {});
in {
  imports = [
    ./utils.nix
    ./sxhkd.nix
    ./dunst.nix
    ./rofi.nix
    ./fzf.nix
    ./fetch.nix
    ./clipmenu.nix
  ] ++ (if usr.wmType == "x11" then [ ./sxhkd.nix ] else [ ]);
  home.packages = lib.mkIf (usr.wmType == "wayland") [
    swhkd
  ];
}
