{ inputs, config, sys, lib, pkgs, usr, ... }:
let
  cfg = config.m.wm.wayland;
  inherit (lib) mkOption types mkIf mkMerge;
in
{
  options.m.wm.wayland = {
    enable = mkOption {
      description = "enables wayland";
      type = types.bool;
      default = usr.wmType == "wayland";
    };
  };
  imports = [ ./swhkd.nix ];
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # why do i need this again?
      wayland
      lxqt.lxqt-policykit
    ];
  };
}
