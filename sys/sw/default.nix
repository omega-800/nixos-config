{lib, ...}: {
  imports = [
    ./stylix.nix
    ./fonts.nix
    ./flatpak.nix
    ./printing.nix
    ./miracast.nix
  ];
  options.m.sw.enable = lib.mkEnableOption "enables misc software";
}
