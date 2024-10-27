{
  lib,
  pkgs,
  usr,
  ...
}:
let
  swhkd = (pkgs.callPackage ./swhkdPkg.nix { });
in
{
  home.packages = lib.mkIf (usr.wmType == "wayland") [ swhkd ];
  home.file.".config/swhkd/swhkdrc".text = ''
    Super + o
      rofi -show drun
  '';
}
