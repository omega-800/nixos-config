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
  # imports = [ ./swhkd.nix ];
  config = mkIf cfg.enable {
    # services.swhkd = {
    #   enable = true;
    #   swhkdrc = ''
    #     super + shift + s 
    #       flameshot gui
    #   '';
    # };
    environment.systemPackages = with pkgs; [
      # why do i need this again?
      wayland
      # apparently this i definitely need
      lxqt.lxqt-policykit
    ];
  };
}
