{ lib, sys, pkgs, ... }:
with lib; {

  u = {
    net.enable = mkForce false;
    posix.enable = mkForce true;
    file = {
      enable = mkForce false;
      lf.enable = mkForce false;
    };
    utils = {
      enable = mkForce true;
      fzf.enable = mkForce true;
    };
    dev = {
      enable = mkForce false;
      git.enable = mkForce true;
    };
    user = {
      enable = mkForce false;
      nixvim.enable = mkForce true;
      tmux.enable = mkForce true;
    };
    nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  };
}
