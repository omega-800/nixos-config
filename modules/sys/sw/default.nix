{ lib, sys, pkgs, ... }: {
  imports = [
    ./stylix.nix
    ./fonts.nix
    ./flatpak.nix
    ./printing.nix
    ./miracast.nix
    ./android.nix
  ];
  options.m.sw.enable = lib.mkEnableOption "enables misc software";
}
