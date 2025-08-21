{ pkgs, lib, ... }:
let
  inherit (lib) mkForce;
in
{
  u = {
    dev.enable = mkForce false;
    posix.enable = mkForce false;
    work.enable = mkForce false;
    file.enable = mkForce true;
    net.enable = mkForce true;
    office.enable = mkForce false;
    user = {
      enable = mkForce true;
      # crashes the pc for some reason?
      nixvim.enable = mkForce false;
    };
    utils.enable = mkForce true;
    media.enable = mkForce false;
    social.enable = mkForce false;
  };
  home.packages = with pkgs; [ unifi8 ];
}
